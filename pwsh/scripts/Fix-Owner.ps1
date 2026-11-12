#Requires -Version 7.0

$path = (Get-Location).Path
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$acl = Get-Acl -LiteralPath $path

$ownerSid = $acl.GetOwner(
    [System.Security.Principal.SecurityIdentifier]
)

$data = [PSCustomObject]@{
    Directory = $path
    Owner     = $acl.Owner
    Current   = $user.Name
}
$data | Format-List

if ($ownerSid -eq $user.User) {
    Write-Output "Owner is already correct."
} else {
    Write-Output "Fixing owner..."
    & icacls.exe $path /setowner $user.Name

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to change owner. Try an elevated PowerShell."
    }

    Write-Output "New owner: $((Get-Acl -LiteralPath $path).Owner)"
}
