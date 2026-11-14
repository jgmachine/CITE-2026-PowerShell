<#
.SYNOPSIS
Checks that your lab is ready. Green is good, yellow is optional, red needs fixing.

.EXAMPLE
./setup/Test-Lab.ps1
#>
[CmdletBinding()]
param(
    [string] $ServerUri = 'http://localhost:8080'
)

$repo = Split-Path $PSScriptRoot -Parent
$script:problems = 0

function Write-Check([string] $Name, [bool] $Passed, [string] $Fix, [switch] $Optional) {
    if ($Passed) {
        Write-Host "  [ok]   $Name" -ForegroundColor Green
    }
    elseif ($Optional) {
        Write-Host "  [--]   $Name. $Fix" -ForegroundColor Yellow
    }
    else {
        Write-Host "  [FAIL] $Name. $Fix" -ForegroundColor Red
        $script:problems++
    }
}

Write-Host "`nChecking the lab...`n" -ForegroundColor Cyan

Write-Check "PowerShell $($PSVersionTable.PSVersion)" ($PSVersionTable.PSVersion -ge [version]'7.4') 'Install PowerShell 7.4 or newer: https://aka.ms/powershell'

foreach ($name in 'Pode', 'Microsoft.PowerShell.SecretManagement', 'Microsoft.PowerShell.SecretStore') {
    Write-Check "Module $name" ([bool](Get-Module -ListAvailable -Name $name)) 'Run ./setup/Install-Prereqs.ps1'
}

$examples = @((Get-Help Invoke-RestMethod -Examples -ErrorAction SilentlyContinue).examples.example).Count
Write-Check 'Help files installed' ($examples -gt 1) 'Run Update-Help -Scope CurrentUser (Get-Help works without it, just with fewer examples)' -Optional

foreach ($name in 'RickMortyApi', 'DistrictTools', 'MultiverSIS') {
    $loaded = try { Import-Module (Join-Path $repo "modules/$name") -Force -PassThru -ErrorAction Stop } catch { $null }
    Write-Check "Lab module $name loads" ([bool]$loaded) "Check modules/$name for errors"
}

$snapshot = Join-Path $repo 'modules/RickMortyApi/Data/characters.json'
$count = if (Test-Path $snapshot) { @(Get-Content $snapshot -Raw | ConvertFrom-Json).Count } else { 0 }
Write-Check "Offline snapshot ($count characters)" ($count -gt 800) 'The file modules/RickMortyApi/Data/characters.json is missing'

$online = try { [bool](Invoke-RestMethod 'https://rickandmortyapi.com/api/character/1' -TimeoutSec 5) } catch { $false }
Write-Check 'Rick and Morty API reachable' $online 'No problem: the demos fall back to the offline snapshot' -Optional

$server = try { (Invoke-RestMethod "$ServerUri/health" -TimeoutSec 3).status -eq 'ok' } catch { $false }
Write-Check "MultiverSIS running at $ServerUri" $server 'Start it in another terminal: ./server/Start-MultiverSIS.ps1' -Optional

$vault = try { [bool](Get-SecretVault -ErrorAction Stop) } catch { $false }
Write-Check 'A SecretManagement vault is registered' $vault "See the 'Before you start' lines in demos/demo.ps1" -Optional

if ($script:problems) {
    Write-Host "`n$($script:problems) thing(s) to fix. Everything else is ready.`n" -ForegroundColor Red
}
else {
    Write-Host "`nThe lab is ready. Wubba lubba lab lab!`n" -ForegroundColor Green
}
