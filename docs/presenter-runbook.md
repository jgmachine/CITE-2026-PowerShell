# Presenter runbook

Everything you need to run the session without surprises. Timing marks are in each slide's presenter notes too.

## The week before

1. On the presenting Mac, install the tools:
   ```bash
   brew install powershell node
   ```
   Plus VS Code with the PowerShell extension. (GitHub Copilot only if you want to try the AI step live.)
2. Clone the repo, then in `pwsh`:
   ```powershell
   ./setup/Install-Prereqs.ps1
   ./setup/Test-Lab.ps1
   ```
3. Install the deck: `cd slides`, then `npm install`.
4. Public repo: the QR codes on the title and act slides, and the address in every footer, point to `themeConfig.repo`. Make the repo public before the talk or attendees will hit a 404. (The QR code on the last slide goes to LinkedIn.)
5. Start the server once (`./server/Start-MultiverSIS.ps1`), then put its key in a vault:
   ```powershell
   Register-SecretVault -Name LabVault -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
   Set-Secret -Name MultiverSIS -Secret (Get-Content ./server/data/apikey.txt)
   Set-SecretStoreConfiguration -PasswordTimeout 3600
   ```
6. Rehearse the whole of [`demos/demo.ps1`](../demos/demo.ps1), top to bottom, in VS Code, with a timer. No step depends on a live AI service.
7. Make backups:
   - A PDF of the deck is already in the repo: [`from-scripts-to-systems.pdf`](../from-scripts-to-systems.pdf). It was made on 2026-11-14; if you change slides after that, export a fresh one (in `slides/`, run `npm install -D playwright-chromium`, then `npm run export`).
   - A screen recording of the Act III and Act V demos (QuickTime: File > New Screen Recording).

## 30 minutes before

- [ ] Focus / Do Not Disturb on. Quit Slack, Teams, and mail.
- [ ] VS Code zoomed in (Cmd +) with `demos/demo.ps1` open.
- [ ] A separate terminal: `./server/Start-MultiverSIS.ps1 -Reset`
- [ ] In VS Code, run the "Before you start" lines at the top of `demo.ps1`: they import the modules and unlock the vault, so it doesn't ask for its password mid-demo.
- [ ] Browser tab: `http://localhost:8080` (the dashboard).
- [ ] Slides: `cd slides`, then `npm run dev`. Presenter view: `http://localhost:3030/presenter`.
- [ ] `./setup/Test-Lab.ps1` one last time.

## The demos

All of them live in one file, [`demos/demo.ps1`](../demos/demo.ps1), in the order you'll use them. Each act is a collapsible section. Put the cursor on a line and press **F8** to run it, or copy and paste into a terminal.

Run everything in the same VS Code terminal. Variables like `$ricks` and `$new`, the SIS connection, and the unlocked vault all live in that one session.

## Screen layout

- **Slides:** full screen on the projector, presenter view on the laptop.
- **Demos:** VS Code on the left half, dashboard on the right half. The dashboard also appears live on the "Meet MultiverSIS" slide.

## Slide keys

| Key | What it does |
|---|---|
| Space, →, Page Down | Next click or slide (clickers work) |
| ←, Page Up | Back |
| ↑ / ↓ | Previous / next slide, skipping click steps |
| `o` | Slide overview |
| `g` | Go to a slide number |
| `f` | Full screen |

## Run of show

30 slides, 4 clicks. Everything else appears on its own.

| Time | Segment | In `demo.ps1` |
|---|---|---|
| 0:00 | Title, about me, recommended reading, lab census (show of hands), what we'll cover | |
| 3:00 | Cold open: "Is this talk obsolete?" | |
| 5:30 | Act I: The three commands, syntax | Act I, part 1 (6 lines) from the three-commands slide; part 2 (9 lines) from the syntax slide; part 3 (5 lines) from the Live demo slide |
| 12:45 | Find your small problem | |
| 15:30 | Act II: Script → system | Act II (4 lines, optional) |
| 23:00 | Act III: Lego bricks | Act III (8 lines) |
| 32:30 | Act IV: Secrets | Act IV (2 lines) |
| 35:00 | Act V: Teach AI your tricks | Act V (4 lines). No live AI |
| 43:15 | Homework, then questions with the LinkedIn QR code up | |

It's a full 45 minutes. If you're behind at the halfway mark (Act III should start by 23:00), skip the Act II lines, the "What have you automated?" shout-out, and the bricks slide.

## When things break

| Problem | Do this |
|---|---|
| No internet | RickMortyApi switches to its offline snapshot by itself. For Act I, run the offline line in the comment above `Invoke-RestMethod`. |
| Server crashed | Rerun `./server/Start-MultiverSIS.ps1` (without `-Reset` to keep the data), then run the `Connect-MultiverSIS` line again. |
| Vault asks for a password | Type it. That's the vault doing its job. |
| "Your API key is from the wrong dimension" | The key in the vault doesn't match the server's. Store it again: `Set-Secret -Name MultiverSIS -Secret (Get-Content ./server/data/apikey.txt)`, then reconnect. |
| "Address already in use" when starting the server | An old MultiverSIS is still running on port 8080. Find its terminal and press Ctrl+C, or run `lsof -ti tcp:8080 \| xargs kill` on the Mac, then start it again. |
| You try the AI live and it misbehaves | The pipeline it should have written is in `demo.ps1`, right under the prompt. Run that. "This is why you learn to read the code." |
| Everything is on fire | The slides already show the key output (the pipeline, the dashboard). Keep talking. |

## The AI prompt (optional, if there's time at the end)

The Act V demo doesn't use a live AI: you show the prompt and the script it produces, and run the script yourself. If you have time to spare, the prompt is in `demo.ps1` under Act V, ready to copy into Copilot Chat (Agent mode):

> Learn the MultiverSIS module with Get-Command and Get-Help. Then write a script, withdraw.ps1, that withdraws every student whose enrollment status is Unknown. Use -WhatIf. Don't run it; I'll review it and run it myself.

Copilot should read `.github/copilot-instructions.md`, run `Get-Command -Module MultiverSIS` and `Get-Help`, and write a `Get-SISStudent -EnrollmentStatus Unknown | Set-SISStudent -EnrollmentStatus Withdrawn -WhatIf` pipeline. You read it out loud and run it yourself: `-WhatIf` first (24 students), then for real. On the dashboard, Unknown drops to 0.

Why Copilot only writes the script: it works in its own terminal, which isn't connected to the SIS and can't unlock your vault. Learning the module with `Get-Command` and `Get-Help` needs neither. Delete `withdraw.ps1` after each rehearsal.

## Reset between rehearsals

Click **Reset demo data** at the bottom of the dashboard. It puts the SIS back to the four starter students without a restart, and your PowerShell session stays connected.

Or restart the server with fresh data:

```powershell
./server/Start-MultiverSIS.ps1 -Reset
```
