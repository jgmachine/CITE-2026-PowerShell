# Copilot instructions for this repo

A PowerShell 7 teaching lab for district IT. Every student in it is fake.

## Before you write any code

- Import the module, then run `Get-Command -Module MultiverSIS` to see what exists.
- Run `Get-Command <name> -Syntax` and `Get-Help <name> -Examples` before using a command.
- Use our functions. Never invent a command or parameter you haven't verified.
- Scripts connect with `Connect-MultiverSIS -ApiKey (Get-Secret MultiverSIS)`. Don't run that yourself: the vault needs a human to unlock it.
- Write the script with `-WhatIf` on anything that changes data, and let the human review and run it.

## Use our modules instead of calling APIs directly

- **RickMortyApi**: `Get-RMCharacter` reads the "vendor" API. It handles paging and works offline.
- **DistrictTools**: `ConvertTo-SISStudent` turns a character into a student record.
- **MultiverSIS**: `Connect-MultiverSIS` first, then `Get-SISStudent`, `New-SISStudent`, `Set-SISStudent`, `Get-SISSchool`.

Every command has help: `Get-Help <command> -Examples`. They accept pipeline input by property name, so they chain:

```powershell
Get-RMCharacter -Name rick | ConvertTo-SISStudent | New-SISStudent -WhatIf
```

## House rules

- Verb-Noun names with approved verbs (`Get-Verb`). One function per file, in `Public/` or `Private/`.
- Output objects, not text. No `Write-Host` for data and no `Format-*` inside functions.
- Anything that changes data uses `[CmdletBinding(SupportsShouldProcess)]` so it supports `-WhatIf`.
- Every public function gets comment-based help with at least one `.EXAMPLE`.
- Never put secrets in code. Read them with `Get-Secret` from SecretManagement.
- When suggesting a command that writes to MultiverSIS, show the `-WhatIf` version first.
