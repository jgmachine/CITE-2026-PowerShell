#Requires -Version 7.4

<#
.SYNOPSIS
Installs what the lab needs, for your user account only. Safe to run more than once.

.DESCRIPTION
Installs three modules from the PowerShell Gallery:
  - Pode: runs the MultiverSIS web server
  - Microsoft.PowerShell.SecretManagement: one set of commands for any secret vault
  - Microsoft.PowerShell.SecretStore: a cross-platform vault for the API key

Then downloads PowerShell's help files, so Get-Help has examples to show you.
Works on macOS, Windows, and Linux with PowerShell 7.4 or newer.

.EXAMPLE
./setup/Install-Prereqs.ps1
#>
[CmdletBinding()]
param()

# The exact versions this lab was tested with. Anything newer in the same major version is fine too.
$modules = @(
    @{ Name = 'Pode'; Tested = '2.14.1'; Why = 'runs the MultiverSIS web server' }
    @{ Name = 'Microsoft.PowerShell.SecretManagement'; Tested = '1.1.2'; Why = 'one set of commands for any vault' }
    @{ Name = 'Microsoft.PowerShell.SecretStore'; Tested = '1.0.6'; Why = 'a cross-platform vault' }
)

Write-Host "`nInstalling lab prerequisites for $([Environment]::UserName)...`n" -ForegroundColor Cyan

foreach ($module in $modules) {
    $tested = [version]$module.Tested
    $compatible = Get-Module -ListAvailable -Name $module.Name |
        Where-Object { $_.Version -ge $tested -and $_.Version.Major -eq $tested.Major } |
        Select-Object -First 1

    if ($compatible) {
        Write-Host "  $($module.Name) $($compatible.Version) is already installed." -ForegroundColor Green
    }
    else {
        Write-Host "  Installing $($module.Name) $tested ($($module.Why))..."
        Install-PSResource -Name $module.Name -Version $module.Tested -Scope CurrentUser -TrustRepository -Quiet
    }
}

Write-Host "`n  Downloading help files so Get-Help has examples (about a minute)..."
Update-Help -Scope CurrentUser -UICulture en-US -ErrorAction SilentlyContinue

Write-Host "`nDone. Next, check everything:  ./setup/Test-Lab.ps1`n" -ForegroundColor Green
