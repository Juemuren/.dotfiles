$ErrorActionPreference = 'Stop'

$installPath = $env:MISE_TOOL_INSTALL_PATH
$installers = @(Get-ChildItem -LiteralPath $installPath -File -Filter 'signed_Rocq-Platform-release-*-Windows*.exe')
if ($installers.Count -ne 1) {
    throw "Expected one Rocq installer in '$installPath', found $($installers.Count)."
}

# Skip the NSIS wizard resources and uninstaller data.
& 7z x $installers[0].FullName "-o$installPath" -y '-x!$PLUGINSDIR' '-x!Uninstall.exe.nsis' | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "7-Zip failed to extract Rocq (exit code $LASTEXITCODE)."
}

$root = $installPath.Replace('\', '/')
@(
    "ROCQLIB=`"$root/lib/coq`""
    "OCAMLFIND=`"$root/bin/ocamlfind.exe`""
) | Set-Content -LiteralPath (Join-Path $installPath 'bin/coq_environment.txt') -Encoding utf8
