param(
    [Parameter(Mandatory)]
    [string]$Destination
)

New-Item -ItemType Directory -Path $Destination -Force | Out-Null
Invoke-WebRequest https://github.com/SuperCuber/dotter/releases/latest/download/dotter-windows-x64-msvc.exe -OutFile (Join-Path $Destination 'dotter.exe')
