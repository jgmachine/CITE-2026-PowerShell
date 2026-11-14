# From Scripts to Systems: every command from the talk, in order.
#
# Open this file in VS Code and press F8 to run the line your cursor is on
# (or select several lines first). Or copy and paste lines into any PowerShell 7 terminal.
# Run everything from the repo's top folder.


#region Before you start (setup, not part of the talk)

# In a second terminal, start the fake SIS and leave it running:
#     ./server/Start-MultiverSIS.ps1 -Reset
# Then open the dashboard in a browser:  http://localhost:8080
# (Running the demo again? Click "Reset demo data" at the bottom of the dashboard. No restart needed.)

Import-Module ./modules/RickMortyApi, ./modules/DistrictTools, ./modules/MultiverSIS -Force

# First time only: put the lab's API key in a vault. (It asks you to choose a vault password.)
#     Register-SecretVault -Name LabVault -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
#     Set-Secret -Name MultiverSIS -Secret (Get-Content ./server/data/apikey.txt)

Unlock-SecretStore

#endregion


#region Act I, part 1: three commands
# START HERE from the "Three commands. That's it." slide.

# Find: commands are Verb-Noun. Guess the noun.
Get-Command
Get-Command *process*
Get-Command -Noun Process

# Learn: the examples are the best part.
Get-Help Get-Process -Examples

# Inspect: it looks like text, but it's objects.
Get-Process | Get-Member

# Objects sort and pick columns. What's eating the memory?
Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name, Id, WorkingSet64

# <<< BACK TO THE SLIDES: "Syntax in 60 seconds"
#endregion


#region Act I, part 2: syntax
# START HERE from the "Syntax in 60 seconds" slide.

# A variable. Double quotes fill it in; single quotes don't.
$name = 'Rick'

"Hi, $name"

'Hi, $name'

# Compare with -like. The answer is True or False.
$name -like 'R*'

# A hashtable is a lookup table: give it a key, get the value back.
$students = @{ 1001 = 'Morty'; 1002 = 'Summer'; 1003 = 'Beth' }

$students[1002]

# A dot gets a property, and -gt compares.
$students.Count -gt 2

# Nearly all of it in one line: a variable in quotes, the pipe, $_, a dot, two comparisons, parameters.
$find = 'code'

Get-Process | Where-Object { $_.Name -like "*$find*" -and $_.WorkingSet64 -gt 50MB } | Sort-Object WorkingSet64 -Descending | Select-Object -First 3 Name, Id

# <<< BACK TO THE SLIDES: "Today's data source"
#endregion


#region Act I, part 3: the same syntax, on a web API
# START HERE from the "Live demo: Meet the Ricks" slide.

# Same three commands, on something new: a web API. Keep the answer in a variable.
# The API's own site and documentation:  https://rickandmortyapi.com
# (No Wi-Fi?  $ricks = Get-Content ./demos/offline/ricks-page1.json | ConvertFrom-Json )
$ricks = Invoke-RestMethod 'https://rickandmortyapi.com/api/character/?name=rick'

$ricks | Get-Member

$ricks.info

# 107 Ricks. How many came back? Only 20: that's pagination.
$ricks.results.Count

# Filter: $_ is "the current Rick", and -eq compares.
$ricks.results | Where-Object { $_.status -eq 'Dead' } | Select-Object name, status

# <<< BACK TO THE SLIDES: "Find your small problem"
#endregion


#region Act II: script to system
# START HERE from the "Watch it grow" slide, after v5. (Optional: skip if you're behind.)

# The finished function follows every page. All 107.
(Get-RMCharacter -Name rick).Count

# [ValidateSet()] catches a typo before it reaches the API.
Get-RMCharacter -Name rick -Status Zombie

# -Verbose came free with [CmdletBinding()].
# (Want a log file? See ./demos/logging-example.ps1: Write-Host, Write-Verbose and Start-Transcript.)
Get-RMCharacter -Name rick -Status Alive -Verbose | Select-Object -First 3

# Help comments become real help.
Get-Help Get-RMCharacter -Examples

# <<< BACK TO THE SLIDES: "I turned myself into a module!"
#endregion


#region Act III: Lego bricks
# START HERE from the "Live demo: Build a student body" slide. Dashboard visible.

# Connect to the SIS. (Where does the key come from? That's Act IV.)
Connect-MultiverSIS -ApiKey (Get-Secret MultiverSIS)

# Our SIS has four students. Budget cuts.
Get-SISStudent

# Vendor data -> district rules. One Rick, before and after.
Get-RMCharacter -Name rick | Select-Object -First 1 | Format-List *

Get-RMCharacter -Name rick | Select-Object -First 1 | ConvertTo-SISStudent | Format-List *

# Every Rick, converted. (Our rules skip six of the 107.) Nothing has touched the SIS yet.
$new = Get-RMCharacter -Name rick | ConvertTo-SISStudent

# -WhatIf first. Always.
$new | Select-Object -First 3 | New-SISStudent -WhatIf

# For real this time. Watch the dashboard. (Then click a student to open their profile.)
$new | New-SISStudent

# A report nobody asked for, in one line.
Get-SISStudent | Group-Object School -NoElement | Sort-Object Count -Descending | Select-Object -First 3

# <<< BACK TO THE SLIDES: Act IV, "Who Guards the Guardians?"
#endregion


#region Act IV: secrets
# START HERE from the "Do this instead: a vault" slide.

# That Get-Secret from Act III: the key lives in a vault, not in the script.
Get-Secret MultiverSIS

Get-SecretVault

# <<< BACK TO THE SLIDES: Act V, "Teach AI Your Tricks"
#endregion


#region Act V: teach AI your tricks
# START HERE from the "Live demo: Read it. Then run it." slide.

# What the AI reads to learn your module: the same commands as Act I.
Get-Command -Module MultiverSIS

Get-Help Set-SISStudent -Examples

# The prompt you'd give an AI agent (Copilot, Claude Code, Codex):
#
#   Learn the MultiverSIS module with Get-Command and Get-Help. Then write a script,
#   withdraw.ps1, that withdraws every student whose enrollment status is Unknown.
#   Use -WhatIf. Don't run it; I'll review it and run it myself.
#
# This is the script it writes back. Read it before you run it.
# (Extra time? Paste the prompt into your agent and compare.)
Get-SISStudent -EnrollmentStatus Unknown | Set-SISStudent -EnrollmentStatus Withdrawn -WhatIf

# 24 students. That looks right. For real this time: watch the dashboard.
Get-SISStudent -EnrollmentStatus Unknown | Set-SISStudent -EnrollmentStatus Withdrawn

# <<< BACK TO THE SLIDES: "Just because you can..."
#endregion
