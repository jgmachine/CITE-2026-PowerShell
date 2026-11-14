# Worksheet: find your small problem

Fifteen minutes with this page beats an afternoon of "I should really automate something."

## 1. List what you repeat

Write down five things you did more than once this month.

| Task | How often? | Minutes each | Systems involved |
|---|---|---|---|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

## 2. Do the math

**Minutes each × times per year ÷ 60 = hours per year.**

Five minutes, every school day: 5 × 180 ÷ 60 = **15 hours a year**. That's worth an afternoon of scripting.

## 3. Pick one

Circle the task that:

- [ ] happens at least weekly
- [ ] has a clear input and a clear output
- [ ] can start **read-only** (it reports; it doesn't change anything yet)
- [ ] annoys *you* the most (you'll actually finish it)

## 4. Say it in one sentence

> Given __________________, produce __________________.

Example: *Given a Chromebook serial number, produce the student who has it and their homeroom.*

## 5. Find the commands

```powershell
Get-Command *<noun>*                  # what can talk to this system?
Get-Help <command> -Examples          # how do I use it?
<command> | Get-Member                # what came back?
```

## 6. Grow it up, one step at a time

- [ ] **v1:** a one-liner that works for you, today
- [ ] **v2:** a script (hardcoded values are fine, for now)
- [ ] **v3:** a function with **parameters** that **outputs objects**
- [ ] **v4:** `[CmdletBinding()]`, typed parameters, `[ValidateSet()]` where it fits
- [ ] **v5:** comment-based help with an `.EXAMPLE`
- [ ] **v6:** a module (`Public/`, `Private/`, a `.psd1` manifest)

## 7. Before it changes anything

- [ ] It supports `-WhatIf` (`[CmdletBinding(SupportsShouldProcess)]`)
- [ ] You tested it against test data, not production
- [ ] Secrets come from a vault (`Get-Secret`), not the script
- [ ] If it touches student data, it went through your district's approval process

## 8. Share it

- [ ] A README that says what it does and how to run it
- [ ] Help comments good enough that `Get-Help` answers the first question
- [ ] A line in `.github/copilot-instructions.md` so your AI knows it exists
