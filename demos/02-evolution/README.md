# From script to tool: the same code, five times

Each file is the same idea, grown up a little more.

| Version | File | What changed |
|---|---|---|
| v1 | [v1-one-liner.ps1](v1-one-liner.ps1) | It works. Once. Only the first 20 results. |
| v2 | [v2-script.ps1](v2-script.ps1) | Follows every page. Hardcoded name and path, text output. |
| v3 | [v3-function.ps1](v3-function.ps1) | A parameter. Outputs objects; the caller decides what to do with them. |
| v4 | [v4-advanced-function.ps1](v4-advanced-function.ps1) | `[CmdletBinding()]`, typed parameters, `[ValidateSet()]`, `Write-Verbose`, clean output objects. |
| v5 | [../../modules/RickMortyApi](../../modules/RickMortyApi) | A module: a manifest (`.psd1`), public and private functions, comment-based help, offline fallback. |

Try each one:

```powershell
. ./demos/02-evolution/v4-advanced-function.ps1
Get-RMCharacter rick -Status Alive -Verbose
```

The module version:

```powershell
Import-Module ./modules/RickMortyApi
Get-Help Get-RMCharacter -Examples
```
