# A simple way to log a script. Not in the talk; here because there wasn't room.
#
# Run it:                 ./demos/logging-example.ps1
# Run it with details:    ./demos/logging-example.ps1 -Verbose
# Then open the log file it names at the end.

[CmdletBinding()]
param()

# Start-Transcript saves everything the console shows to a file, from here to Stop-Transcript.
$log = Join-Path ([IO.Path]::GetTempPath()) "logging-example-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
Start-Transcript -Path $log | Out-Null

# Write-Host is for messages a person should always see. It always lands in the log.
Write-Host 'Starting the nightly Rick count...'

# Write-Verbose is for detail. It shows, and is logged, only when the script runs with -Verbose.
Write-Verbose 'Importing the RickMortyApi module.'
Import-Module "$PSScriptRoot/../modules/RickMortyApi" -Force -Verbose:$false

$ricks = Get-RMCharacter -Name rick
Write-Verbose "The API returned $($ricks.Count) characters."

Write-Host "Found $($ricks.Count) Ricks. $(($ricks | Where-Object Status -eq 'Alive').Count) are alive."

Stop-Transcript | Out-Null
Write-Host "Log saved to $log"
