#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat << 'EOF'
Usage: sh fastfetch/preprocess-logo.sh INPUT OUTPUT_DIR [OPTIONS]

Generate ImageMagick variants in a new directory and preview each with Chafa.
Pick a PNG, then run convert-logo.sh to save the chosen braille or block logo.

Range options accept N or START:END:STEP (inclusive, nonnegative integers):
    --contrast RANGE       Sigmoidal contrast strength (default: 4)
    --saturation RANGE     Saturation percent (default: 125)
    --line-strength RANGE  Amount of contour darkening, 0-100% (default: 25)
    --line-width RANGE     Contour dilation radius in pixels (default: 1)

Other options:
    --crop GEOMETRY        Optional ImageMagick crop, e.g. 1350x1350+260+180
    --midpoint N           Sigmoidal contrast midpoint percent (default: 72)
    --edge-scale N         Scale percent for contour detection (default: 30)
    --canny-low N          Canny low threshold percent (default: 10)
    --canny-high N         Canny high threshold percent (default: 30)
    --preview MODE         braille, block, both, or none (default: block)

Example:
    sh fastfetch/preprocess-logo.sh anime.png .tmp/logo-trials \
        --crop 1350x1350+260+180 --contrast 2:6:2 \
        --saturation 100:130:15 --line-strength 0:50:25
EOF
}

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
    usage
    exit 0
fi
if (($# < 2)); then
    usage >&2
    exit 2
fi

input=$1
output_dir=$2
shift 2

contrast_spec=4
saturation_spec=125
line_strength_spec=25
line_width_spec=1
crop=
midpoint=72
edge_scale=30
canny_low=10
canny_high=30
preview=block

while (($# > 0)); do
    if (($# < 2)); then
        printf 'Missing value for %s\n' "$1" >&2
        exit 2
    fi
    case "$1" in
        --contrast) contrast_spec=$2 ;;
        --saturation) saturation_spec=$2 ;;
        --line-strength) line_strength_spec=$2 ;;
        --line-width) line_width_spec=$2 ;;
        --crop) crop=$2 ;;
        --midpoint) midpoint=$2 ;;
        --edge-scale) edge_scale=$2 ;;
        --canny-low) canny_low=$2 ;;
        --canny-high) canny_high=$2 ;;
        --preview) preview=$2 ;;
        *)
            printf 'Unknown option: %s\n' "$1" >&2
            exit 2
            ;;
    esac
    shift 2
done

expand_range() {
    local spec=$1 start end step value
    if [[ $spec =~ ^[0-9]+$ ]]; then
        printf '%s\n' "$((10#$spec))"
        return
    fi
    if [[ ! $spec =~ ^([0-9]+):([0-9]+):([0-9]+)$ ]]; then
        printf 'Invalid range: %s\n' "$spec" >&2
        return 2
    fi
    start=$((10#${BASH_REMATCH[1]}))
    end=$((10#${BASH_REMATCH[2]}))
    step=$((10#${BASH_REMATCH[3]}))
    if ((step == 0 || start > end)); then
        printf 'Invalid range: %s\n' "$spec" >&2
        return 2
    fi
    for ((value = start; value <= end; value += step)); do
        printf '%s\n' "$value"
    done
}

for value in "$midpoint" "$edge_scale" "$canny_low" "$canny_high"; do
    if [[ ! $value =~ ^[0-9]+$ ]]; then
        printf 'Expected a nonnegative integer: %s\n' "$value" >&2
        exit 2
    fi
done
midpoint=$((10#$midpoint))
edge_scale=$((10#$edge_scale))
canny_low=$((10#$canny_low))
canny_high=$((10#$canny_high))
if ((midpoint > 100 || edge_scale == 0 || canny_low > 100 || canny_high > 100 || canny_low >= canny_high)); then
    printf 'Invalid midpoint, edge scale, or Canny thresholds\n' >&2
    exit 2
fi
case "$preview" in
    braille | block | both | none) ;;
    *)
        printf 'Invalid preview mode: %s\n' "$preview" >&2
        exit 2
        ;;
esac

contrast_values=$(expand_range "$contrast_spec")
saturation_values=$(expand_range "$saturation_spec")
line_strength_values=$(expand_range "$line_strength_spec")
line_width_values=$(expand_range "$line_width_spec")
mapfile -t contrasts <<< "$contrast_values"
mapfile -t saturations <<< "$saturation_values"
mapfile -t line_strengths <<< "$line_strength_values"
mapfile -t line_widths <<< "$line_width_values"
for line_strength in "${line_strengths[@]}"; do
    if ((line_strength > 100)); then
        printf 'Line strength must be 0-100: %s\n' "$line_strength" >&2
        exit 2
    fi
done

crop_args=()
if [[ -n $crop ]]; then
    if [[ ! $crop =~ ^[0-9]+x[0-9]+[+-][0-9]+[+-][0-9]+$ ]]; then
        printf 'Crop must be WIDTHxHEIGHT+X+Y: %s\n' "$crop" >&2
        exit 2
    fi
    crop_args=(-crop "$crop" +repage)
fi
image_size=$(magick "$input" "${crop_args[@]}" -format '%wx%h' info:)
mkdir -p -- "$(dirname -- "$output_dir")"
mkdir -- "$output_dir"
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
manifest="$output_dir/candidates.tsv"
printf 'file\tcontrast\tsaturation\tline_strength\tline_width\n' > "$manifest"

index=0
for contrast in "${contrasts[@]}"; do
    for saturation in "${saturations[@]}"; do
        for line_strength in "${line_strengths[@]}"; do
            for line_width in "${line_widths[@]}"; do
                index=$((index + 1))
                printf -v filename 'candidate-%04d.png' "$index"
                output="$output_dir/$filename"

                grade_args=()
                if ((contrast > 0)); then
                    grade_args+=(-sigmoidal-contrast "${contrast}x${midpoint}%")
                fi
                if ((saturation != 100)); then
                    grade_args+=(-modulate "100,${saturation},100")
                fi

                if ((line_strength == 0)); then
                    magick "$input" "${crop_args[@]}" "${grade_args[@]}" "$output"
                else
                    edge_args=(-resize "${edge_scale}%" -colorspace Gray
                        -canny "0x1+${canny_low}%+${canny_high}%")
                    if ((line_width > 0)); then
                        edge_args+=(-morphology Dilate "Disk:$line_width")
                    fi
                    magick "$input" "${crop_args[@]}" \
                        \( +clone "${edge_args[@]}" -resize "${image_size}!" \
                        -fx "1-($line_strength/100)*u" \) \
                        -compose Multiply -composite "${grade_args[@]}" "$output"
                fi

                printf '%s\t%s\t%s\t%s\t%s\n' \
                    "$filename" "$contrast" "$saturation" "$line_strength" "$line_width" >> "$manifest"
                printf '%s  contrast=%s saturation=%s line=%s width=%s\n' \
                    "$output" "$contrast" "$saturation" "$line_strength" "$line_width"
                if [[ $preview == braille || $preview == both ]]; then
                    sh "$script_dir/convert-logo.sh" braille "$output" -
                fi
                if [[ $preview == block || $preview == both ]]; then
                    sh "$script_dir/convert-logo.sh" block "$output" -
                fi
            done
        done
    done
done
