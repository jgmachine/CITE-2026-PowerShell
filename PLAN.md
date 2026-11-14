# PLAN: From Scripts to Systems (CITE 2026)

Behind-the-scenes notes: the decisions behind this talk and the repo.

## Decisions (locked)

| Topic | Decision |
|---|---|
| Presenting from | District MacBook, PowerShell 7 |
| Deck | Slidev: arrow keys / spacebar / clicker to advance, presenter notes, builds to GitHub Pages, works fully offline (fonts bundled, no CDN) |
| Fake SIS | **MultiverSIS**: a small web API written in PowerShell with the Pode module, plus a live dashboard in the browser. |
| "Vendor" API | rickandmortyapi.com, with an offline snapshot inside the module for conference Wi-Fi |
| Follow-along | Yes, on Mac or Windows with PowerShell 7.4+. One install script, one checklist script |
| Tests | **No Pester.** `setup/Test-Lab.ps1` is a plain checklist |
| MCP | Our own ~150-line PowerShell MCP server. It builds every tool description from `Get-Command` + `Get-Help`. We checked `pwsh.mcp`: it passes only the synopsis, drops parameter help and `ValidateSet` values |
| Art | Original lab/portal/goo art. No show characters or logos in the deck. The API's own avatar images appear only in the live dashboard |

## Run of show (45 min)

30 slides and 4 clicks. Bullets and cards fade in on their own; clicks are kept only for comedic timing or thinking time.

| Time | Segment | Beat |
|---|---|---|
| 0:00 | Title, about me, recommended reading, lab census (show of hands), what we'll cover | |
| 3:00 | **Cold open**: "Is this talk obsolete?" | AI writes good code now, so why are you here? Read it, direct it, build it. |
| 5:30 | **Act I**: The three commands | One slide for `Get-Command`, `Get-Help`, `Get-Member` with a short demo on `Get-Process` (part 1), a syntax cheat sheet with its own short demo (part 2), the data-source slide, then the third demo (part 3): `$ricks = Invoke-RestMethod ...`. `Get-Member` reveals pagination (107 Ricks, 20 per page) |
| 12:45 | Find your small problem | "Is it worth automating?" |
| 15:30 | **Act II**: Script → system | Magic-move: one-liner → script → function → advanced function → help. The bare-minimum module: one `.psm1`, then a manifest, then Public/Private, then share it |
| 23:00 | **Act III**: Lego bricks | MultiverSIS dashboard, the bricks, the cross-system pipeline, live demo: vendor records become student records, with clickable profiles on the dashboard |
| 32:30 | **Act IV**: Secrets | Short on purpose: don't put passwords in scripts, and here's the lead on what to do instead (`Get-Secret`, a vault, gMSA for scheduled tasks) |
| 35:00 | **Act V**: Teach AI your tricks | Three levels (writes PowerShell → writes with your tools → runs your tools). Four steps to make a module AI-ready: make it findable, instructions file, help comments, make it check with `Get-Command`/`Get-Help`. The demo shows what the AI reads, the prompt, and the script it writes; you read it and run it (no live AI unless there's time at the end). Safety. MCP is optional, not the headline |
| 43:15 | Homework, then questions with the LinkedIn QR code and resources up | |

## The Lego pipeline (the whole talk in 3 lines)

```powershell
Get-RMCharacter -Name Rick |          # "vendor" API      (RickMortyApi module)
    ConvertTo-SISStudent |            # your district glue (DistrictTools module)
    New-SISStudent                    # fake SIS           (MultiverSIS module)

```

## Repo map

```
CITE-2026-PowerShell/
├─ README.md             quick start, demos, MCP setup, resources, credits
├─ LICENSE               MIT
├─ setup/                Install-Prereqs.ps1, Test-Lab.ps1
├─ modules/              RickMortyApi (with its offline snapshot), DistrictTools, MultiverSIS
├─ server/               Start-MultiverSIS.ps1 (Pode API) + public/index.html (dashboard)
├─ demos/                demo.ps1 (every command from the talk, in order) + 02-evolution/
├─ mcp/                  Start-MultiverSISMcp.ps1 (plain-PowerShell MCP server)
├─ docs/                 from-scripts-to-systems.pdf, worksheet.md, presenter-runbook.md
├─ slides/               Slidev deck (slides.md, components/, layouts/, styles/)
├─ .vscode/mcp.json      Copilot's MCP config (prompts for the API key)
└─ .github/              copilot-instructions.md, workflows/deploy-slides.yml
```

## Cut to keep it simple
Pester, chaos/retry mode, SIS paging, a separate helpdesk module/key, Out-ConsoleGridView, per-demo folders, a live Keychain demo. Later: the step-through demo player and one script per act (now a single `demo.ps1` run with F8), the Export-Clixml and turtles slides (secrets is a lead, not a lesson), the helpdesk half of the fake SIS, teaching `-WhatIf` internals, and MCP as a headline (it's an optional extra in `mcp/`).

## Verified facts (Sept 2026)
- Export-Clixml on macOS: the password is stored as hex-encoded UTF-16 plaintext. Decoded live on this Mac.
- Current books: *Learn PowerShell in a Month of Lunches* 4th ed. (2022); *Learn PowerShell Scripting in a Month of Lunches* 2nd ed. (Mar 2024).
- Windows Credential Manager vault: `SecretManagement.JustinGrote.CredMan` (last updated 2020). For domain setups, `SecretManagement.DpapiNG` (2025) lets members of an AD group decrypt a secret.
- MCP spec 2026-07-28 is stateless (`server/discover`, per-request `_meta`). Our server also accepts the older `initialize` handshake.
- Module versions tested: Pode 2.14.1, SecretManagement 1.1.2, SecretStore 1.0.6 on PowerShell 7.6.5 (macOS).

## Still open
- Make the repo public and turn on GitHub Pages before the talk (the QR codes on the title and act slides point here)
