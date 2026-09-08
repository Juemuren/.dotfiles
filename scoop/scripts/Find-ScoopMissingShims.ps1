<#
.SYNOPSIS
查找应用中未声明为 Scoop shim 的可执行文件。
.DESCRIPTION
查找应用安装目录下的所有 exe 文件，并与 Scoop 的清单文件进行对比。
.PARAMETER Pattern
对两组名称应用的正则表达式，在转为小写后、排序比较前进行替换。
.PARAMETER Replacement
正则替换文本，默认为空字符串。仅在指定 Pattern 时生效。
.EXAMPLE
Find-ScoopMissingShims.ps1 sysinternals -Pattern '(32|64|-x86|-x64)$' -Verbose
移除名称末尾的 -x64 / -x86 / 32 / 64，并完整显示转换后的可执行文件和 shim 名称。
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AppName,
    [string]$Pattern,
    [string]$Replacement = ''
)

$bins = @(
    fd -e exe . "$(scoop prefix $AppName)" --format '{/.}'
    | ForEach-Object {
        $name = $_.ToLowerInvariant()
        if ($Pattern) { $name = $name -replace $Pattern, $Replacement }
        $name
    }
    | Sort-Object -Unique
)

$shims = @(
    scoop info $AppName
    | Select-Object -ExpandProperty Binaries
    | ForEach-Object {
        # Scoop 以竖线分隔多个入口；只保留路径末尾的名称并移除 exe 扩展名。
        $_ -split ' \| ' -replace '.*\\' -replace '\.exe$'
    }
    | ForEach-Object {
        $name = $_.ToLowerInvariant()
        if ($Pattern) { $name = $name -replace $Pattern, $Replacement }
        $name
    }
    | Sort-Object -Unique
)

Write-Verbose "`n$($PSStyle.Foreground.Cyan)Executable names ($($bins.Count)):`n$($bins -join "`n")$($PSStyle.Reset)`n"
Write-Verbose "`n$($PSStyle.Foreground.Magenta)Shim names ($($shims.Count)):`n$($shims -join "`n")$($PSStyle.Reset)`n"

$bins | Where-Object { $_ -notin $shims }
