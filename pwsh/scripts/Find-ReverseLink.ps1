#Requires -Version 7.0

<#
.SYNOPSIS
Finds links in a source directory that point to a target file.

.PARAMETER Target
Target file, relative to the current directory or absolute.

.PARAMETER Source
Directory to search, relative to the current directory or absolute. Defaults to the current directory.

.EXAMPLE
Find-ReverseLink.ps1 -Target .\data -Source .\projects

.EXAMPLE
Find-ReverseLink.ps1 -Target .\data
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$Target,

    [Parameter(Position = 1)]
    [AllowEmptyString()]
    [string]$Source
)

$currentDirectory = (Get-Location).ProviderPath
$targetPath = [System.IO.Path]::GetFullPath($Target, $currentDirectory)
$sourceDirectory = if ($Source) {
    [System.IO.Path]::GetFullPath($Source, $currentDirectory)
}
else {
    $currentDirectory
}

$comparison = if ($IsWindows) {
    [System.StringComparison]::OrdinalIgnoreCase
}
else {
    [System.StringComparison]::Ordinal
}

Get-ChildItem -LiteralPath $sourceDirectory -Recurse -Force -Attributes ReparsePoint |
    Where-Object {
        if (-not $_.LinkTarget) {
            return $false
        }
        $linkDirectory = [System.IO.Path]::GetDirectoryName($_.FullName)
        $linkTarget = [System.IO.Path]::GetFullPath($_.LinkTarget, $linkDirectory)
        [string]::Equals($linkTarget, $targetPath, $comparison)
    } |
    Select-Object -ExpandProperty FullName
