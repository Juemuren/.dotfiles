# Input is modules.json
# - $bootstrap is boolean
# - $selected is x,y,z

# The manifest's module order is the execution order, with dependencies first.
def expand($dependencies):
  [ .[] | recurse(($dependencies[.] // [])[]) ] | unique;

. as $manifest
| ($selected | gsub(","; " ") | split(" ") | map(select(length > 0)) | unique) as $selected_modules
| (
  if $bootstrap then
    $selected_modules
    | expand($manifest.dependencies)
  else
    $selected_modules
  end
) as $modules
| ($modules - $manifest.modules) as $unknown
| if $unknown != [] then
    error("unknown modules: " + ($unknown | join(", ")))
  else
    $manifest.modules[]
    | select(. as $module | $modules | index($module))
  end
