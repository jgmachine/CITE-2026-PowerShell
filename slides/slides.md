---
theme: default
title: From Scripts to Systems
titleTemplate: '%s · CITE 2026'
info: |
  ## From Scripts to Systems: Building Reusable PowerShell Tools for District IT
  CITE Annual Conference 2026. Slides, demos, and the MultiverSIS lab are all in the repo.
author: Jesse Geron
colorSchema: dark
layout: title
fonts:
  sans: Nunito Variable
  mono: JetBrains Mono Variable
  provider: none
highlighter: shiki
lineNumbers: false
transition: fade-out
mdc: true
drawings:
  persist: false
download: false
exportFilename: from-scripts-to-systems
themeConfig:
  repo: https://github.com/jgmachine/CITE-2026-PowerShell
---

<RepoCard class="title-repo" :size="120" />

<style>
.title-repo { position: absolute; right: 1.2rem; bottom: 1rem; }
</style>

<!--
[0:00] Let the title sit while people find seats. The portal is animated; the cursor on the laptop blinks.

Welcome. Housekeeping: 45 minutes, and everything I show is in a GitHub repo. The QR code on this slide gets you there, and it comes back on every act slide and at the end, with the address at the bottom of every slide. So don't worry about photographing code.
-->

---

# Lab personnel

<div class="grid grid-cols-[320px_1fr] gap-10 mt-6 items-center">

<div class="badge">
  <div class="badge-head">MultiverSIS Lab · Access Badge</div>
  <img class="badge-photo" src="/presenter.webp" alt="Cartoon portrait of Jesse Geron">
  <div class="badge-name">Jesse Geron</div>
  <div class="badge-role">Director, Information Technology<br>Chico Unified School District</div>
  <div class="badge-clearance">Clearance: Local Admin<br><span>(please don't tell anyone)</span></div>
</div>

<div>

- **First ever CITE session!** - 1 of 3
<br><br>
- **Director of IT** at Chico USD - July 2026
- 13 years at **Shasta UHSD**
<br><br>
- Senior Programmer, **10+ years** of PowerShell
- Similar work for **30+ LEAs**: think at scale
<br><br>
- **MBA, IT Management**, WGU - 2023
- **CITE TMAP** Cohort 6 - 2024

</div>
</div>

<style>
.badge {
  padding: 16px;
  border-radius: 14px;
  background: linear-gradient(170deg, #f3e6c8, #d9c9a4);
  color: var(--ink);
  text-align: center;
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.5);
  transform: rotate(-3deg);
}
.badge-head { font-size: 0.75rem; font-weight: 900; letter-spacing: 0.14em; text-transform: uppercase; background: var(--portal-deep); color: #f3ffe6; margin: -16px -16px 12px; padding: 7px; border-radius: 14px 14px 0 0; }
.badge-photo { display: block; width: 128px; height: 160px; object-fit: cover; object-position: 50% 20%; border-radius: 10px; border: 2px solid var(--portal-deep); margin: 0 auto 10px; }
.badge-name { font-family: var(--font-marker); font-size: 1.5rem; }
.badge-role { font-size: 1rem; font-weight: 700; opacity: 0.85; line-height: 1.3; }
.badge-clearance { margin-top: 10px; font-size: 1rem; font-weight: 800; color: #8a1d33; }
.badge-clearance span { font-weight: 600; opacity: 0.8; }
</style>

<!--
[0:30] Bullets are short on purpose; say the rest. Keep this under a minute.

- First CITE session, ever.
- 13 years at Shasta Union High School District, as Senior Programmer. About 10 of those years writing PowerShell.
- We did the same work for 30+ outside districts and COEs, so everything had to work at scale. That habit (build it once, run it for everyone) is what this whole talk is about: scripts to systems.
- MBA in IT Management from WGU, 2023. TMAP Cohort 6, 2024.
- Became Director of Information Technology at Chico Unified this summer.
- These days it's more budgets and meetings than PowerShell, but CITE asked for technical sessions, so here's the technical stuff.
-->

---

# Lab census

<p class="sub">Raise your hand if you're a...</p>

<div class="census stagger">
  <div><div class="i-ph-flask-duotone icon" /><b>Fresh specimen</b><p>Never used PowerShell</p></div>
  <div><div class="i-ph-test-tube-duotone icon" /><b>Lab assistant</b><p>Dabbled. Copied a script or two.</p></div>
  <div><div class="i-ph-atom-duotone icon" /><b>Mad scientist</b><p>I write my own functions and modules</p></div>
</div>

<style>
.sub { margin-top: -0.6rem; color: var(--lab-muted); font-size: 1.4rem; }
.census { display: grid; grid-template-columns: repeat(3, 1fr); gap: 22px; margin-top: 1.6rem; }
.census > div { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 8px; padding: 24px 18px; border: 1px solid var(--lab-line); border-radius: 16px; background: var(--lab-panel); }
.census .icon { font-size: 4rem; color: var(--portal); }
.census b { font-size: 1.6rem; color: var(--portal-light); }
.census p { margin: 0; font-size: 1.2rem; color: var(--lab-muted); }
</style>

<!--
[1:15] Quick show of hands. Read each card and pause for hands.

1. "Fresh specimens: never opened PowerShell." Welcome. The first half is for you.
2. "Lab assistants: dabbled, copied a script or two." Most rooms are mostly this. Good.
3. "Mad scientists: you write your own functions and modules." Keep your hands up... you're my backup if the demo breaks. (Laugh.)

Use the answer: lots of fresh specimens means slow down in Act I. Lots of mad scientists means move faster through Act I and spend the time in Acts III and V.
-->

---

# Lab manuals

<p class="sub">You can't learn PowerShell in 45 minutes. But you can learn where to start.</p>

<div class="books stagger">
  <a class="book lab-panel" href="https://www.manning.com/books/learn-powershell-in-a-month-of-lunches" target="_blank">
    <img class="cover" src="/book-lunches.jpg" alt="Cover of Learn PowerShell in a Month of Lunches, fourth edition">
    <div>
    <div class="step">Start here</div>
    <div class="title">Learn PowerShell in a Month of Lunches</div>
    <div class="meta">4th ed. · Manning, 2022 <span class="go">↗ manning.com</span></div>
    </div>
  </a>
  <a class="book lab-panel" href="https://www.manning.com/books/learn-powershell-scripting-in-a-month-of-lunches-second-edition" target="_blank">
    <img class="cover" src="/book-scripting.jpg" alt="Cover of Learn PowerShell Scripting in a Month of Lunches, second edition">
    <div>
    <div class="step">Then this</div>
    <div class="title">Learn PowerShell Scripting in a Month of Lunches</div>
    <div class="meta">2nd ed. · Manning, 2024 <span class="go">↗ manning.com</span></div>
    </div>
  </a>
</div>

<div class="free stagger">
  <a href="https://learn.microsoft.com/training/modules/introduction-to-powershell/" target="_blank"><div class="i-ph-graduation-cap-duotone icon" /><div><b>Microsoft Learn</b><span>Intro to PowerShell, free</span><i>↗ learn.microsoft.com</i></div></a>
  <a href="https://www.reddit.com/r/PowerShell/" target="_blank"><div class="i-ph-chats-teardrop-duotone icon" /><div><b>r/PowerShell</b><span>Ask anything. Show your code.</span><i>↗ reddit.com</i></div></a>
  <a href="https://leanpub.com/shell-of-an-idea" target="_blank"><div class="i-ph-book-open-text-duotone icon" /><div><b>Shell of an Idea</b><span>How PowerShell got made.</span><i>↗ leanpub.com</i></div></a>
</div>

<style>
.sub { margin-top: -0.6rem; color: var(--lab-muted); font-size: 1.25rem; }
.books { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 1.1rem; }
.book { padding: 16px 20px; display: flex; gap: 20px; align-items: center; }
.book .cover { width: 104px; flex: none; border-radius: 4px; box-shadow: 0 8px 22px rgba(0, 0, 0, 0.55); }
.book .step { font-family: var(--font-marker); color: var(--amber); font-size: 1.2rem; }
.book .title { font-size: 1.45rem; font-weight: 800; font-style: italic; color: var(--portal-light); line-height: 1.25; margin: 4px 0 8px; }
.book .meta { color: var(--lab-muted); font-size: 1.05rem; }
.free { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-top: 1.1rem; }
.books a, .free a { color: inherit; text-decoration: none; border-style: solid; }
.books a:hover, .free a:hover { border-color: var(--portal); }
.book .go, .free i { color: var(--teal); font-style: normal; font-size: 1.05rem; }
.book .go { display: block; margin-top: 4px; }
.free i { display: block; margin-top: 2px; }
.free .icon { flex: none; font-size: 2.8rem; color: var(--portal); }
.free > a { display: flex; gap: 16px; align-items: center; padding: 10px 18px !important; border: 1px solid var(--lab-line); border-radius: 12px; padding: 12px 14px; }
.free b { display: block; font-size: 1.1rem; color: var(--portal); }
.free span { display: block; color: var(--lab-muted); font-size: 1.1rem; margin-top: 2px; }
</style>

<!--
[1:45] Set expectations: 45 minutes can't teach PowerShell. It can show you where it goes. These two books are the classic path.

- Month of Lunches: one short chapter a day, written for admins, not programmers. Get the current edition; older ones are Windows PowerShell 5.1 era.
- The Scripting book picks up where this talk leaves off: functions, modules, help, tools other people can use.

Free: Microsoft Learn's "Introduction to PowerShell" module, hands-on and beginner-level. r/PowerShell is friendly to beginners who show their code.

Just for fun: "Shell of an Idea" by Don Jones (who also co-wrote the Lunches books). It's the story of how PowerShell got built inside Microsoft, and how close it came to not shipping. Not a how-to. "I thought it was really cool. But I'm also a dork."

Every card is a link in the online slides, and everything is in the repo README, so nobody needs to write it down.
-->

---

# What we'll cover

<div class="roadmap stagger">
  <div><span class="n">1</span><b>Three commands</b><span class="d">Get-Command, Get-Help, Get-Member</span></div>
  <div><span class="n">2</span><b>Scripts → Tools</b><span class="d">One-liner, script, function, module</span></div>
  <div><span class="n">3</span><b>Lego bricks</b><span class="d">Snap tools together into a system</span></div>
  <div><span class="n">4</span><b>Secrets</b><span class="d">Where the API keys live</span></div>
  <div class="ai"><span class="n">5</span><b>AI lab assistant</b><span class="d">Go fast, once you can read the code</span></div>
</div>

<style>
.roadmap { display: grid; gap: 12px; margin-top: 1.4rem; align-content: start; }
.roadmap > div { display: grid; grid-template-columns: 52px 290px 1fr; align-items: center; gap: 18px; padding: 10px 20px; border-radius: 14px; background: var(--lab-panel); border: 1px solid var(--lab-line); }
.roadmap .n { display: grid; place-items: center; width: 44px; height: 44px; border-radius: 50%; background: var(--portal-deep); color: #f3ffe6; font-weight: 900; font-size: 1.3rem; }
.roadmap b { font-size: 1.45rem; color: var(--portal-light); }
.roadmap .d { font-size: 1.25rem; color: var(--lab-muted); }
.roadmap .ai { border-color: var(--teal); box-shadow: 0 0 24px rgba(80, 230, 210, 0.18); }
.roadmap .ai b { color: var(--teal); }
</style>

<!--
[2:30] The map. Each step builds on the one before it.

1. The three commands you use to figure out everything else.
2. Grow a one-liner into a real tool: script, function, advanced function, module.
3. Snap those tools together, like Lego, across systems that were never designed to talk to each other.
4. Where to keep the passwords and API keys those tools need.
5. And then AI. It's a huge accelerator, but only once you can read what it gives you. Which brings us to the obvious question...
-->

---

# Is this talk obsolete?

<div class="chat">
  <div class="prompt"><span class="who">You</span> Write me a PowerShell script that syncs our students to Google Workspace.</div>
  <div class="reply"><span class="who-ai">AI</span> Done. Four seconds. And it's good.</div>
</div>

<p class="why-q">So why are you here?</p>

<div class="why stagger">
  <div class="lab-panel"><div class="i-ph-eye-duotone icon" /><b>Read it</b><p>You don't have to write it. You should be able to read it.</p></div>
  <div class="lab-panel"><div class="i-ph-compass-duotone icon" /><b>Direct it</b><p>Know what a good tool looks like, and you can ask for one.</p></div>
  <div class="lab-panel"><div class="i-ph-wrench-duotone icon" /><b>Build it</b><p>Simple, solid, predictable tools. For people <i>and</i> AI.</p></div>
</div>

<style>
.chat { display: grid; gap: 10px; justify-items: start; margin-top: 0.2rem; font-size: 1.3rem; }
.prompt { padding: 10px 18px; border-radius: 16px 16px 16px 4px; background: #16352b; border: 1px solid var(--lab-line); }
.prompt .who { font-weight: 900; color: var(--teal); margin-right: 8px; }
.reply { padding: 10px 18px; border-radius: 16px 16px 4px 16px; border: 1px solid var(--lab-line); justify-self: end; }
.reply .who-ai { font-weight: 900; color: var(--amber); margin-right: 8px; }
.why-q { margin: 1.1rem 0 0.6rem; font-family: var(--font-marker); font-size: 2rem; color: var(--amber); }
.why { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
.why .lab-panel { padding: 16px 20px 18px; }
.why .icon { font-size: 2.6rem; color: var(--portal); }
.why b { display: block; margin-top: 4px; font-size: 1.7rem; color: var(--portal-light); }
.why p { margin: 6px 0 0; font-size: 1.3rem; line-height: 1.35; }
</style>

<!--
[3:00] The cold open. Say the question the room is already thinking: "Why sit through a PowerShell talk if AI can just write the code for you?"

Read the prompt out loud. "A couple of years ago this slide was a list of AI mistakes: made-up commands, a password in plain text. That slide is out of date. Today it comes back in four seconds and the code is good."

So why are you here? Three reasons, and they're the next 40 minutes:

- Read it. You don't have to write every line anymore. But you should be able to read one when you want to. Story: ask for "sync our students to Google" and a good script removes every Google account that isn't in the student export. That's every teacher, and the superintendent. Nothing is wrong with the code. The AI just doesn't know your district. You do, and reading it is how you catch that.
- Direct it. If you know how a good tool is put together (functions, parameters, modules), you can ask for one, instead of asking for "a script."
- Build it. Small, solid tools that give the same result every time. A person can run them. An AI can run them. Either way you know what's going to happen.

Bridge into Act I: "So let's start with reading."
-->

---
layout: act
act: I
transition: portal
---

# The Three Commands

Everything else, PowerShell will tell you.

<!--
[5:30] Act I. The only three commands you actually need to memorize.
-->

---

# Three commands. That's it.

<div class="cmds stagger">
  <div class="cmd">
    <div class="head"><div class="verb">Find</div><div class="name">Get-Command</div></div>
    <p>It's <b>Verb-Noun</b>. Guess the noun.</p>
    <pre class="mini">Get-Command *csv*
Get-Command -Noun *Process*</pre>
  </div>
  <div class="cmd">
    <div class="head"><div class="verb">Learn</div><div class="name">Get-Help</div></div>
    <p>Run <code>Update-Help</code> once. Read <b class="nowrap">-Examples</b>.</p>
    <pre class="mini">Get-Help Invoke-RestMethod -Examples
Get-Help about_Splatting</pre>
  </div>
  <div class="cmd">
    <div class="head"><div class="verb">Inspect</div><div class="name">Get-Member</div></div>
    <p>It's an <b>object</b>. Look inside.</p>
    <pre class="mini">$response | Get-Member</pre>
  </div>
</div>

<DemoCue>Act I, part 1</DemoCue>

<div class="loop-row">
  <p class="loop">↻ Find, learn, inspect, repeat.</p>
  <StickyNote :rotate="3" color="#d8f5c8">PowerShell can teach you PowerShell.</StickyNote>
</div>

<style>
.cmds { display: grid; gap: 12px; margin-top: 0.2rem; }
.cmd { display: grid; grid-template-columns: 190px 1fr 380px; gap: 20px; align-items: center; padding: 10px 18px; border: 1px solid var(--lab-line); border-radius: 14px; background: var(--lab-panel); }
.cmd .verb { font-family: var(--font-marker); color: var(--amber); font-size: 1.1rem; }
.cmd .name { font-family: 'JetBrains Mono Variable', monospace; font-weight: 800; font-size: 1.45rem; color: var(--portal); }
.cmd p { font-size: 1.3rem; line-height: 1.3; margin: 0; }
.mini { margin: 0; padding: 10px 14px; border-radius: 8px; background: #020a06; border: 1px solid #2c6a3f; font-family: 'JetBrains Mono Variable', monospace; font-size: 16px; line-height: 24px; color: #d6ffc4; white-space: pre; overflow: hidden; }
.loop-row { display: grid; grid-template-columns: 1fr 280px; gap: 24px; align-items: center; margin-top: 0.3rem; }
.loop { font-size: 1.5rem; color: var(--lab-muted); margin: 0; }
</style>

<!--
[5:45] The whole skill on one slide. Walk left to right:

Find: commands are Verb-Noun on purpose, and the verbs come from an approved list (Get-Verb). If you can guess the noun, wildcards find the command. That consistency matters again in Act V, when a robot has to guess what your commands do.

Learn: confession, a brand-new install shows almost nothing until you run Update-Help. -Examples is the best part. And about_ topics are help for ideas instead of commands: when you don't understand the idea (what's that @ sign?), there's an about_ topic for it. Get-Help about_* lists them.

Inspect: you don't have to know what an API returns. Ask the object.

The sticky note is the joke. Read it, then pause.

DEMO, right from this slide: switch to VS Code, demos/demo.ps1, "Act I, part 1". F8 runs the line the cursor is on. About a minute and a half.
- Find: Get-Command by itself is a wall of commands. Narrow it with *process*, then with -Noun Process.
- Learn: Get-Help Get-Process -Examples.
- Inspect: Get-Process | Get-Member. "It looks like text. It's objects."
- Sort by memory: "what's eating my RAM" is a help desk question everyone in the room has answered. (WorkingSet64 is memory in use, in bytes.)
Then back here, to the syntax slide.
-->

---

# Syntax in 60 seconds

<div class="syntax stagger">
  <div><code>$name = 'Rick'</code><span>Variables start with <b>$</b></span></div>
  <div><code>"Hi, $name"</code><span>Double quotes fill in variables</span></div>
  <div><code>$user.Email</code><span>A dot gets a property</span></div>
  <div><code>-Name 'Rick'</code><span>Parameters start with <b>-</b></span></div>
  <div><code>Get-Process | Sort-Object CPU</code><span>The pipe passes objects along</span></div>
  <div><code>{ $_.Status -eq 'Alive' }</code><span><b>$_</b> is "the current one"</span></div>
  <div><code>-eq  -ne  -gt  -lt  -like</code><span>Compare. Not <b>==</b> or <b>&gt;</b></span></div>
  <div><code>@{ 1001 = 'Morty'; 1002 = 'Summer' }</code><span>A hashtable: look things up by key</span></div>
</div>

<DemoCue place="bottom">Act I, part 2</DemoCue>

<div class="gotcha"><StickyNote :rotate="-2" color="#ffd9a8"><code>if ($x &gt; 5)</code> doesn't compare anything. It creates a file named <b>5</b>.</StickyNote></div>

<style>
.syntax { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 22px; margin-top: 0.5rem; }
.syntax > div { display: flex; flex-direction: column; gap: 4px; padding: 6px 16px; border: 1px solid var(--lab-line); border-radius: 12px; background: var(--lab-panel); }
.syntax code { all: unset; font-family: 'JetBrains Mono Variable', monospace; font-size: 18px; font-weight: 700; color: #d6ffc4; white-space: pre; }
.syntax span { font-size: 1.15rem; color: var(--lab-muted); }
.syntax b { color: var(--portal-light); font-family: 'JetBrains Mono Variable', monospace; font-variant-ligatures: none; }
.syntax code { font-variant-ligatures: none; }
.gotcha { position: absolute; right: 3.2rem; top: 1.1rem; width: 380px; }
.gotcha :deep(.note) { font-size: 1.05rem; padding: 14px 16px 10px; }
</style>

<!--
[7:30] Back from the first demo. Just enough syntax to read the rest of today's demos. Don't teach it; point at it.

- $ means variable. = assigns. That's it.
- Double quotes expand variables; single quotes are literal. Use single unless you need the variable.
- Dot for properties. That's what Get-Member just showed us.
- Parameters start with a dash. Tab completion fills them in; press Tab a lot.
- The pipe passes whole objects, not text.
- Inside Where-Object and friends, $_ means "the object we're on right now."
- The big one for anyone coming from other languages: comparisons are -eq, -gt, -like. Not == or >.
- @{ } is a hashtable: a lookup table. Give it a key, get the value back, like finding a student by ID. (You'll also see @{ } used to build objects and to pass a set of parameters; same braces, different job.)

DEMO, right from this slide: demo.ps1, "Act I, part 2". About a minute. Every line is something on this slide:
- $name = 'Rick', then the same text in double quotes and in single quotes. Double fills in the variable; single doesn't.
- A comparison that answers True: -like with a wildcard.
- A hashtable of students keyed by ID, then a lookup with square brackets. "This is how you find one student out of thousands without looping." Then a dot and -gt: how many are in it?
- The last line uses nearly everything at once: a variable inside double quotes, the pipe, $_, a dot, -like and -gt, and parameters. Read it left to right like a sentence: "get the processes, keep the ones with 'code' in the name that use more than 50 megabytes, biggest first, top three."
Then on to the data source slide.

Sticky note: > is redirection in PowerShell, like in cmd and bash. if ($x > 5) writes $x into a file named 5 and is always true. Everyone does this once.
-->

---

# Today's data source

<a class="api-link" href="https://rickandmortyapi.com" target="_blank"><div class="i-ph-plugs-connected-duotone icon" /><div><b>The Rick and Morty API</b><span>rickandmortyapi.com ↗</span></div></a>

<div class="why-api stagger">
  <div class="lab-panel"><div class="i-ph-gift-duotone icon" /><b>Free and open</b><p>No account. No API key. Try it tonight.</p></div>
  <div class="lab-panel"><div class="i-ph-tree-structure-duotone icon" /><b>Works like a real one</b><p>JSON, filters and paging, like your vendors' APIs.</p></div>
  <div class="lab-panel"><div class="i-ph-shield-check-duotone icon" /><b>Cleaned up. Mostly.</b><p>It's an adult cartoon. I've tried to filter out anything overly crude.</p></div>
</div>

<p class="api-foot">A fun way to show something useful. <b>No real students.</b></p>

<style>
.api-link { display: flex; align-items: center; gap: 18px; margin-top: 1.2rem; padding: 16px 24px; border: 2px solid var(--portal-deep) !important; border-radius: 16px; background: var(--lab-panel); color: var(--lab-text) !important; text-decoration: none !important; }
.api-link .icon { flex: none; font-size: 3.4rem; color: var(--portal); }
.api-link b { display: block; font-size: 1.9rem; line-height: 1.2; }
.api-link span { font-family: 'JetBrains Mono Variable', monospace; font-size: 1.4rem; color: var(--portal-light); }
.why-api { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-top: 1.3rem; }
.why-api .lab-panel { padding: 16px 18px; }
.why-api .icon { font-size: 2.4rem; color: var(--portal); }
.why-api b { display: block; margin-top: 4px; font-size: 1.4rem; color: var(--portal-light); }
.why-api p { margin: 4px 0 0; font-size: 1.2rem; line-height: 1.35; }
.api-foot { margin-top: 1.3rem; text-align: center; font-size: 1.5rem; }
.api-foot b { color: var(--portal); }
</style>

<!--
[8:30] Before we touch it: for the rest of the talk, our "vendor" is the Rick and Morty API. It's a free, public API that a fan built from the show's characters. Anyone can use it, no sign-up, so you can try everything from today on your own laptop tonight.

Why this one: it behaves like the real APIs you deal with. It returns JSON, it has filters, and it pages its results. The skills transfer directly to your SIS, your MDM, your help desk system.

The disclaimer: the show is an adult cartoon, and some of its character names are crude. I've tried to keep anything overly crude off the screen: the demos pull characters that should be fine to show, and the fake SIS skips the worst of it. That's an attempt, not a guarantee. If something slips through, that's the vendor's data, not my sense of humor.

And nothing here is a real student. Click the link if you want to show the site's documentation page for ten seconds.
-->

---
layout: demo
file: demos/demo.ps1 · Act I, part 3
---

# Meet the Ricks

- `$ricks = Invoke-RestMethod ...`
- A dot gets a property: `.info`, `.results`
- Filter with `$_` and `-eq`
- The aha: **107** Ricks, **20** per page

<!--
[9:30] Switch to VS Code: demos/demo.ps1, "Act I, part 3". The same syntax, on real data.

Beats to hit:
- The same three commands, on something you've never seen. $ricks = Invoke-RestMethod ... uses the syntax slide: a variable, an equals sign, done.
- $ricks | Get-Member shows info and results. Dot into them.
- $ricks.info says 107; $ricks.results.Count says 20. "That's pagination. Remember it."
- Where-Object with $_ and -eq: the syntax slide, live.

If Wi-Fi is down: run the offline line in the comment above the Invoke-RestMethod line.
-->

---

# Find your small problem

<div class="small-problem">
<div>

### A good first problem...
<br>

- Happens **every week**
- Takes **5+ minutes**
- Clear **input → output**

</div>
<div>

### District examples
<br>

- New-hire account creation
- Stale computers & accounts
- Nightly SIS export cleanup
- Password resets

</div>
<div class="math lab-panel">
  <div class="eq">5 min × 180 school days</div>
  <div class="ans">= 15 hours a year</div>
  <div class="muted">That's worth an afternoon of scripting.</div>
</div>
<AskRoom class="ask-box">What have <i>you</i> automated?</AskRoom>
</div>

<style>
.small-problem { display: grid; grid-template-columns: 1fr 1fr; gap: 1.4rem 2rem; margin-top: 0.5rem; align-items: start; }
.small-problem > .math, .small-problem > .ask-box { align-self: stretch; }
.small-problem > .ask-box { display: flex; }
.math { display: grid; align-content: center; text-align: center; }
.math .eq { font-size: 1.1rem; font-weight: 700; }
.math .ans { font-family: var(--font-title); font-size: 2.2rem; color: var(--portal); line-height: 1.2; }
</style>

<!--
[12:45] The worksheet in the repo (docs/worksheet.md) walks through this.

Ask the room: "What have you already automated? Shout it out, one sentence." Take three or four quick answers and repeat each one into the mic so the back row hears it. If it's quiet, prime it: "Anybody script account creation? Password resets?" Keep it to about a minute.

Automate the thing that annoys you most, not the thing that impresses your boss most. The first one gets finished.

Resources are on the last slide and in the README.
-->

---
layout: act
act: II
transition: portal
---

# From Scripts to Tools

<div class="defs">
  <div><b>Script:</b> one job, usually hardcoded.</div>
  <div><b>Tool:</b> Reusable functions. Modules hold them.</div>
  <div><b>System:</b> your modules, working together.</div>
</div>

<style>
.slidev-layout:has(.defs) h1 { font-size: 3.2rem !important; white-space: nowrap; }
.defs { display: grid; gap: 22px; margin-top: 5rem; font-size: 1.65rem; white-space: nowrap; line-height: 1.3; color: var(--lab-text); }
.defs b { color: var(--portal-light); }
</style>

<!--
[15:30] Act II. First: scripts are fine. Plenty of them should stay scripts, scheduled and running every night. The problem is when you copy one, change the server name, and now you have five versions to fix. That's when it should grow up.

A tool is a function anyone can reuse; a module is a toolbox full of them. A system is your modules working together on something bigger, like the SIS sync in Act III.

Nobody writes a system on purpose on day one. You write a script, you notice you've copied it three times, and then it grows up. We're going to watch one piece of code do exactly that.
-->

---
class: evolution
---

# Watch it grow

<DemoCue>Act II (optional)</DemoCue>

<div class="step">
  <div v-if="$clicks === 0"><b>v1 · The one-liner.</b> <code>Invoke-RestMethod</code>: one command, and you're talking to an API. First 20 Ricks only.</div>
  <div v-if="$clicks === 1"><b>v2 · The script.</b> Gets every page. Hardcoded everything. Works on my machine. (Not even this one. That's a Windows path.)</div>
  <div v-if="$clicks === 2"><b>v3 · The function.</b> A parameter, and it outputs objects. What you do with them is your business.</div>
  <div v-if="$clicks === 3"><b>v4 · The advanced function.</b> <code>[CmdletBinding()]</code>, types, <code>[ValidateSet()]</code>, <code>-Verbose</code> for free.</div>
  <div v-if="$clicks === 4"><b>v5 · Help comments.</b> Now <code>Get-Help</code> works on <em>your</em> code. It comes back in Act V.</div>
</div>

````md magic-move {lines: false}
```powershell
(Invoke-RestMethod 'https://rickandmortyapi.com/api/character/?name=rick').results |
    Select-Object name, status, species
```

```powershell
$name = 'rick'
$url  = "https://rickandmortyapi.com/api/character/?name=$name"
$all  = @()

while ($url) {
    $page = Invoke-RestMethod $url
    $all += $page.results
    $url  = $page.info.next
}

Write-Host "Found $($all.Count) characters named $name"
$all | Export-Csv 'C:\Users\me\Desktop\ricks_FINAL_v2.csv'
```

```powershell
function Get-RMCharacter {
    param($Name)

    $url = "https://rickandmortyapi.com/api/character/?name=$Name"
    while ($url) {
        $page = Invoke-RestMethod $url
        $page.results
        $url = $page.info.next
    }
}
```

```powershell
function Get-RMCharacter {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)] [string] $Name,
        [ValidateSet('Alive', 'Dead', 'unknown')] [string] $Status
    )
    $url = "https://rickandmortyapi.com/api/character/?name=$Name&status=$Status"
    while ($url) {
        Write-Verbose "GET $url"
        $page = Invoke-RestMethod $url
        foreach ($c in $page.results) {
            [pscustomobject]@{ Name = $c.name; Status = $c.status }
        }
        $url = $page.info.next
    }
}
```

```powershell
function Get-RMCharacter {
    <#
    .SYNOPSIS
    Gets characters from the Rick and Morty API.
    .PARAMETER Name
    All or part of a character's name.
    .EXAMPLE
    Get-RMCharacter -Name rick -Status Alive
    #>
    [CmdletBinding()]
    # ...param() and the body are the same as v4...
}
```
````

<div v-if="$clicks === 0" class="siblings">
  <div class="lab-panel"><code>Invoke-RestMethod</code><p>Automatically turns JSON into <b>PowerShell objects</b>. Perfect for working with API data.</p></div>
  <div class="lab-panel"><code>Invoke-WebRequest</code><p>Gives you the <b>HTTP response</b>: status code, headers, and content. Great for downloads and troubleshooting.</p></div>
</div>

<style>
.evolution h1 { margin-bottom: 0.2em; }
.siblings { display: grid; grid-template-columns: 1fr 1fr; gap: 1.4rem; margin-top: 2.2rem; }
.siblings code { font-size: 1.25rem; }
.siblings p { margin: 0.6rem 0 0; font-size: 1.2rem; line-height: 1.4; }
.siblings b { color: var(--portal-light); }
.evolution { --slidev-code-font-size: 15px; --slidev-code-line-height: 20px; }
.evolution .step { min-height: 1.6em; margin-bottom: 4px; font-size: 1.15rem; }
.evolution .step b { color: var(--portal); }
</style>

<!--
[16:15] Four clicks. Each click, the code morphs into the next version. Narrate what changed each time:

v1: the one-liner. Stop on Invoke-RestMethod for a second: "This is where it got exciting for me. One command, and you're pulling real data out of a system. Once you can get data out of one system and into another, you can automate almost anything." It calls the API and hands back objects, not text. Look up: Invoke-RestMethod. The two boxes: Invoke-RestMethod is the everyday one, because it gives you the data ready to use. Invoke-WebRequest is its sibling, and it's good to know about: it gives you the whole response (status code, headers, raw content). Reach for it to download a file, or when an API call fails and you need to see what actually came back.

It's the first 20 results only, because pagination. Remember Act I?

v2: the script. Now it follows the "next" link. But the name is hardcoded, the path is hardcoded (and it's a Windows path on a Mac), and Write-Host output is only good for human eyeballs.

v3: the function. One parameter. It outputs objects. The caller decides what to do with them. CSV? Filter? Count? Not this function's problem anymore.
v4: the advanced function. [CmdletBinding()] gives you -Verbose and -ErrorAction for free. [ValidateSet()] gives you tab completion and catches typos before they hit the API.


v5: help comments. This is the one people skip. Don't. Get-Help now works on your code, and in Act V a robot is going to read these comments.

DEMO (optional), after v5: switch to VS Code. Four lines in demo.ps1 under "Act II": the finished function returns all 107, rejects -Status Zombie, shows -Verbose, and answers Get-Help. Skip them if you're behind.
-->

---

# I turned myself into a module!

<div class="morph" aria-hidden="true"><span class="pickle">🥒</span><span class="fn">ƒ(x)</span></div>

<div class="modgrid grid grid-cols-[1.15fr_1fr] gap-8 mt-2 items-start">
<div>

<p class="term-label">MyTools/MyTools.psm1</p>

```powershell
function Get-ChromebookOwner {
    param($SerialNumber)
    # ...
}

function New-StaffAccount {
    param($FirstName, $LastName)
    # ...
}
```

</div>
<div>

<p class="term-label">That's a module</p>

```powershell
Import-Module ./MyTools
Get-Command -Module MyTools
```

<div class="grow stagger">
  <div><span>1</span><div>One <code>.psm1</code> in a matching folder</div></div>
  <div><span>2</span><div>Bigger? <code>New-ModuleManifest</code></div></div>
  <div><span>3</span><div>Bigger still? <b>Public/</b> and <b>Private/</b></div></div>
  <div><span>4</span><div>Share it: <b>PowerShell Gallery</b>, <b>GitHub</b></div></div>
</div>

</div>
</div>

<a class="learn-more" href="https://learn.microsoft.com/powershell/scripting/learn/ps101/10-script-modules" target="_blank"><div class="i-ph-book-open-text-duotone icon" /><div><b>Learn it:</b> PowerShell 101, chapter 10, "Script modules." Free on Microsoft Learn. ↗</div></a>

<style>
.modgrid { --slidev-code-font-size: 17px; --slidev-code-line-height: 23px; margin-top: -1rem !important; }
.grow { display: grid; gap: 14px; margin-top: 1.2rem; font-size: 1.2rem; line-height: 1.35; }
.grow > div { display: flex; gap: 12px; align-items: flex-start; }
.grow code { white-space: nowrap; }
.grow span { flex: none; display: grid; place-items: center; width: 32px; height: 32px; border-radius: 50%; background: var(--portal-deep); color: #f3ffe6; font-weight: 900; font-size: 1rem; }
.grow b { color: var(--portal-light); }
.learn-more { display: flex; gap: 12px; align-items: center; margin-top: 0.3rem; padding: 6px 14px; border: 1px solid var(--portal-deep); border-radius: 12px; font-size: 1.15rem; color: var(--lab-text) !important; text-decoration: none !important; border-bottom: 1px solid var(--portal-deep) !important; }
.learn-more .icon { flex: none; font-size: 1.8rem; color: var(--portal); }
.learn-more b { color: var(--portal-light); }
.morph { position: absolute; top: 2.3rem; right: 4rem; width: 90px; height: 70px; z-index: 5; }
.morph .pickle, .morph .fn { position: absolute; left: 50%; top: 50%; font-size: 3rem; transform: translate(-50%, -50%); }
.morph .pickle { animation: pickle-out 4s ease-in-out infinite; }
.morph .fn { font-family: 'JetBrains Mono Variable', monospace; font-weight: 800; color: var(--portal); animation: fn-in 4s ease-in-out infinite; }
@keyframes pickle-out { 0%, 35% { opacity: 1; transform: translate(-50%, -50%) rotate(0deg) scale(1); } 50%, 85% { opacity: 0; transform: translate(-50%, -50%) rotate(540deg) scale(0.2); } 100% { opacity: 1; transform: translate(-50%, -50%) rotate(720deg) scale(1); } }
@keyframes fn-in { 0%, 35% { opacity: 0; transform: translate(-50%, -50%) scale(0.2); } 50%, 85% { opacity: 1; transform: translate(-50%, -50%) scale(1); } 100% { opacity: 0; transform: translate(-50%, -50%) scale(0.2); } }
</style>

<!--
[20:45] "I'm Pickle Rick" callback. (The pickle in the corner keeps turning into a function.)

The bare minimum: rename your .ps1 to .psm1 and put it in a folder with the same name. Every function in it becomes a command. That's a module.

It grows with you:
1. One .psm1 file. Lots of perfectly good modules stay this way.
2. Add a manifest (New-ModuleManifest) when you want a version number, to choose which functions are exported, or to publish to the PowerShell Gallery.
3. Split into Public/ and Private/ folders, one function per file, when the file gets too big to scroll through. That's the community-standard layout, and it's what modules/RickMortyApi in the repo uses: copy it as a template when you get there. (Its Data/ folder is just my Wi-Fi insurance, not part of the pattern.)

4. Share it. Publish to the PowerShell Gallery (Publish-PSResource) and anyone in the world can Install-PSResource it. Put the code in a public GitHub repo and other people can fix bugs and add features with you.

Look up: PowerShell 101, chapter 10, "Script modules," by Mike F. Robbins. It's a free book on Microsoft Learn, and that chapter walks through exactly this: functions, a .psm1, a manifest, public and private functions. The link is on the slide and in the repo.

When you outgrow copying a folder: Sampler is the actively maintained community template.

Act II recap in one breath: parameters instead of hardcoded values, objects out, pipeline in, -WhatIf and -Verbose for free, help comments, and a module. None of these is hard. Together, they're the difference between a script and a system.
-->

---
layout: act
act: III
transition: portal
---

# Lego Bricks from Another Dimension

Two systems nobody designed to work together.

<!--
[23:00] Act III. This is where it gets fun.
-->

---

# Meet MultiverSIS

<div class="grid grid-cols-[1fr_1.25fr] gap-8 mt-2 items-start">
<div>

The **Multiverse Student Information System**.

- A real web API in PowerShell
- Needs an API key
- **Zero real students**
- A live dashboard

</div>
<div>
  <LiveDashboard />
</div>
</div>

<!--
[23:15] The fake SIS runs on this laptop. It's about 200 lines of PowerShell.

If the server is running, the dashboard on this slide is live. If not, you'll see a screenshot.

Start it before the talk: ./server/Start-MultiverSIS.ps1 -Reset
-->

---

# The bricks

<div class="pyr">
  <div class="lvl">Your script</div>
  <div class="row r3"><Brick class="pbrick d5" color="#ffb627" sub="your district's rules">Sync script</Brick></div>

  <div class="lvl">Your modules</div>
  <div class="row r2">
    <Brick class="pbrick d3" color="#8cff3a" sub="reads the vendor">RickMortyApi</Brick>
    <Brick class="pbrick d4" color="#8cff3a" sub="talks to the SIS">MultiverSIS</Brick>
  </div>

  <div class="lvl">Their systems</div>
  <div class="row r1">
    <Brick class="pbrick d1" color="#93a39d" sub="rickandmortyapi.com">Vendor API</Brick>
    <Brick class="pbrick d2" color="#93a39d" sub="student information system">SIS API</Brick>
  </div>
</div>

<div class="rules lab-panel">
  <b>Wrap each system once.</b> Every script after that is short.
</div>

<style>
.pyr { --w: 300px; display: grid; grid-template-columns: 165px 1fr; align-items: center; margin-top: 0.4rem; }
.pyr .lvl { font-size: 0.95rem; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase; color: var(--lab-muted); line-height: 1.2; padding-top: 11px; white-space: nowrap; }
.pyr .row { display: flex; justify-content: center; gap: 2px; position: relative; }
.pyr .r3 { z-index: 3; }
.pyr .r2 { z-index: 2; margin-top: -3px; }
.pyr .r1 { z-index: 1; margin-top: -3px; }
.pyr .pbrick { width: var(--w); min-width: 0; animation: brick-snap 0.55s cubic-bezier(0.3, 1.5, 0.5, 1) backwards; }
.pyr .pbrick :deep(.label) { font-size: 1.25rem; }
.pyr .pbrick :deep(.sub) { font-size: 1.05rem; }
.pyr .d1 { animation-delay: 0.3s; }
.pyr .d2 { animation-delay: 0.7s; }
.pyr .d3 { animation-delay: 1.3s; }
.pyr .d4 { animation-delay: 1.7s; }
.pyr .d5 { animation-delay: 2.4s; }
@keyframes brick-snap { from { opacity: 0; transform: translateY(-70px); } }
.rules { margin-top: 1.3rem; font-size: 1.3rem; }
.rules b { color: var(--portal-light); }
@media (prefers-reduced-motion: reduce) { .pyr .pbrick { animation: none; } }
</style>

<!--
[24:00] The bricks snap in on their own, from the bottom up. Narrate as they land:

- Gray bricks: two systems you don't control. The vendor's API and the SIS. They were never designed to talk to each other.
- Green bricks: one module for each. RickMortyApi reads the vendor; MultiverSIS talks to the SIS. Each one only knows about its own system.
- The orange brick on top is your sync script. It's short, because the modules do the talking. All it holds is your district's rules: which fields go where, and what the vendor's words mean in your SIS.

"Nobody designed these two systems to work together. The script on top is the only thing that knows about both."

Callback to the cold open: this is "Build it." Small, solid bricks that do the same thing every time, whether a person or an AI is the one stacking them.

If someone asks where ConvertTo-SISStudent lives: in the repo it's in a small helper module called DistrictTools, because more than one demo uses it. That's Act II again: when a second script needs the same rules, they move into a module.
-->

---

# The whole talk in one pipeline

<div class="hero">

```powershell
Get-RMCharacter -Name rick |    # the vendor
    ConvertTo-SISStudent |      # your rules
    New-SISStudent -WhatIf      # the SIS
```

</div>

<p class="golden">The golden rule: <b>output objects.</b></p>

<div class="pays stagger">
  <div class="lab-panel"><b>Your tools snap together</b><p>One tool's output is the next tool's input.</p></div>
  <div class="lab-panel"><b>Built-in tools come free</b><p>Filter it. Sort it. Count it. Export it.</p></div>
</div>

<style>
.hero { --slidev-code-font-size: 24px; --slidev-code-line-height: 44px; margin-top: 1rem; }
.golden { margin: 1.1rem 0 0.9rem; text-align: center; font-size: 1.8rem; }
.golden b { color: var(--portal); }
.pays { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.pays .lab-panel { padding: 12px 20px; }
.pays b { font-size: 1.4rem; color: var(--portal-light); }
.pays p { margin: 2px 0 0; font-size: 1.25rem; }
</style>

<!--
[26:30] Read the pipeline top to bottom like a sentence: get the Ricks from the vendor, turn them into student records, create them in the SIS. Two systems that were never designed to work together, and one short script between them.

If people remember one slide, it should be this one. Every one of these tools hands back objects, not a wall of text. That buys you two things:

1. Your tools snap together. ConvertTo-SISStudent outputs an object with a FirstName property. New-SISStudent has a FirstName parameter marked ValueFromPipelineByPropertyName. PowerShell connects them automatically. That one attribute is the Lego stud. (Use the same property names across your tools and it just works.)
2. Built-in tools come free. Swap the last line for Where-Object, Sort-Object, Measure-Object or Export-Csv and it works, on tools you wrote. You didn't write any of that. "Every command after the first is a free feature."

This is why PowerShell is fun.
-->

---
layout: demo
file: demos/demo.ps1 · Act III
---

# Build a student body

- One Rick, before and after your rules
- Then every Rick, into the SIS
- Watch the dashboard fill up, then click a student

<!--
[27:30] Before the talk: ./server/Start-MultiverSIS.ps1 -Reset in its own terminal, dashboard open in a browser, vault unlocked (the "Before you start" lines in demo.ps1).

demo.ps1, the "Act III" section. Screen setup: VS Code on the left, dashboard (localhost:8080) on the right.

Beats:
- Get-SISStudent: "Our SIS has four students. Budget cuts."
- One Rick, before and after ConvertTo-SISStudent. The vendor says status, origin and episode count; the SIS says EnrollmentStatus, School and AttendanceDays. "This function is the only place that knows both vocabularies."
- -WhatIf on three students.
- The real run: point at the dashboard as 101 Ricks come through the portal. (Not 107: ConvertTo-SISStudent skips six by a district rule, the "Fascist" variants. If someone notices the count, that's the point of the function: the rules live in one place.) Click any student to open their full profile: every field in it came through that pipeline.
- Group-Object School: "A report nobody asked for. I didn't write that feature. The pipeline did."

If the server dies: Ctrl+C, rerun Start-MultiverSIS.ps1 (keep the data, no -Reset), reconnect.
-->

---
layout: act
act: IV
transition: portal
---

# Who Guards the Guardians?

Don't put passwords in scripts. Here's what to do instead.

<!--
[32:30] Act IV. Short on purpose. Everyone says "don't put passwords in scripts." Almost nobody says what to do instead.
-->

---

# The crime scene

<div class="tape tape-1">SECRET SCENE · DO NOT CROSS · SECRET SCENE · DO NOT CROSS · SECRET SCENE · DO NOT CROSS ·</div>
<div class="tape tape-2">SECRET SCENE · DO NOT CROSS · SECRET SCENE · DO NOT CROSS · SECRET SCENE · DO NOT CROSS ·</div>

<div class="grid grid-cols-[1.2fr_1fr] gap-8 mt-6 relative z-1">
<div>

```powershell
# sync.ps1
$apiKey   = 'mvs_4f9a2c...'
$password = 'Summer2026!'
```

- `passwords.txt` on the desktop
- One key, 11 scripts, 3 servers
- Pushed to GitHub. Found in minutes.

</div>
<StickyNote class="self-start mt-4" :rotate="4" color="#ffe8a3">The multiverse's most common vulnerability.</StickyNote>
</div>

<style>
.tape { position: absolute; left: -10%; width: 120%; padding: 6px 0; background: repeating-linear-gradient(45deg, #ffcf2e 0 22px, #f2b705 22px 44px); color: #111; font-weight: 900; letter-spacing: 0.12em; font-size: 0.95rem; white-space: nowrap; overflow: hidden; box-shadow: 0 6px 16px rgba(0, 0, 0, 0.5); z-index: 0; opacity: 0.9; }
.tape-1 { top: 80%; transform: rotate(-4deg); animation: tape 20s linear infinite; }
.tape-2 { top: 89%; transform: rotate(3deg); animation: tape 26s linear infinite reverse; }
@keyframes tape { to { text-indent: -600px; } }
</style>

<!--
[32:45] The GitHub one: secret scanning usually finds a pushed key before you finish your coffee. Ask for hands: "Who has a script with a password in it right now?" Keep your own hand up.
-->

---

# Do this instead: a vault

<DemoCue>Act IV</DemoCue>

<div class="vaultcode">

```powershell
Set-Secret -Name MultiverSIS -Secret $key              # once, by hand

Connect-MultiverSIS -ApiKey (Get-Secret MultiverSIS)   # in your script
```

</div>

<div class="vaults stagger">
  <div class="vault"><b>SecretStore</b><span>Microsoft · free · local</span></div>
  <div class="vault"><b>Azure Key Vault</b><span>Microsoft · cloud</span></div>
  <div class="vault"><b>Bitwarden</b><span>Password manager</span></div>
  <div class="vault"><b>1Password</b><span>Password manager</span></div>
  <div class="vault"><b>Keeper</b><span>Password manager</span></div>
  <div class="vault"><b>KeePass</b><span>Password manager</span></div>
</div>

<p class="mt-2 text-2xl">Swap the vault. <b>Your scripts don't change.</b></p>

<p class="lead">Look up: <b>PowerShell SecretManagement</b>. Scheduled tasks on Windows? <b>gMSA</b>.</p>

<style>
.vaultcode { --slidev-code-font-size: 17px; --slidev-code-line-height: 26px; }
.vaults { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 0.4rem; }
.slidev-layout:has(.vaultcode) h1 { margin-bottom: 0.3em; }
.vault { display: flex; flex-direction: column; gap: 2px; padding: 7px 14px; border: 1px solid var(--lab-line); border-radius: 10px; background: var(--lab-panel); }
.vault b { color: var(--portal-light); font-size: 1.25rem; }
.vault span { font-size: 1.05rem; color: var(--lab-muted); }
.lead { margin-top: 0.2rem; font-size: 1.25rem; color: var(--lab-muted); }
.lead b { color: var(--portal-light); }
</style>

<!--
[33:30] The answer to "so what do I do instead?" Microsoft's SecretManagement module gives you Get-Secret and Set-Secret, and the vault behind them is swappable: their free SecretStore, Azure Key Vault, or the password manager your district already pays for.

DEMO: switch to VS Code. Two lines in demo.ps1 under "Act IV": Get-Secret MultiverSIS returns a SecureString, not the key. "That's the line Act III used to connect. The key was never in the script."

This is a lead, not a lesson. Search "PowerShell SecretManagement" and you'll find the setup. For scheduled tasks on Windows, look up gMSA (group managed service accounts): Windows handles the password for you.

If someone asks about Export-Clixml: fine on Windows for a script that runs as you, not encrypted at all on Mac or Linux.
-->

---
layout: act
act: V
transition: portal
---

# Teach AI Your Tricks

You already built the tools. Let AI learn them.

<!--
[35:00] Act V. The one idea: AI gets a lot more useful when it understands the tools you've already built. You don't have to start over.
-->

---

# Three levels of AI help

<div class="levels stagger">
  <div class="level"><span>1</span><div><b>It writes PowerShell</b><p>Ask Copilot, ChatGPT, or Claude. No setup.</p></div></div>
  <div class="level"><span>2</span><div><b>It writes with your tools</b><p>It reads your module. You run the script.</p></div></div>
  <div class="level"><span>3</span><div><b>It runs your tools</b><p>No human presses Run. Start read-only.</p></div></div>
</div>

<style>
.levels { display: grid; gap: 14px; margin-top: 1.2rem; }
.level { display: flex; gap: 20px; align-items: center; padding: 12px 20px; border: 1px solid var(--lab-line); border-radius: 14px; background: var(--lab-panel); }
.level:nth-child(2) { margin-left: 40px; border-color: var(--portal-deep); }
.level:nth-child(3) { margin-left: 80px; }
.level span { flex: none; display: grid; place-items: center; width: 48px; height: 48px; border-radius: 50%; font-family: var(--font-title); font-size: 1.5rem; background: #0f2a21; border: 2px solid var(--portal); color: var(--portal); }
.level b { font-size: 1.45rem; color: var(--portal-light); }
.level p { margin: 2px 0 0; font-size: 1.2rem; color: var(--lab-muted); }
</style>

<!--
[35:15] Level 1 is what most people have tried. It's great at explaining errors and writing boilerplate. Its limit is the cold open: it writes good code, but it doesn't know your district or the tools you've already built.

Level 2 is where the payoff is. The AI can see your module, read your help, and write scripts that use YOUR functions instead of reinventing them. You still read the script and you still press Run. Setting that up (open the module in VS Code, add an instructions file) is the next slide.

Level 3: the AI is the operator. An agent in VS Code can run PowerShell itself (with your permission), or you expose specific commands through an MCP server. The difference from level 2 is who runs it: a bad script at level 2 gets caught when you read it; a bad command at level 3 has already happened.

The demo coming up is level 2: what the AI reads to learn the module, the prompt you'd give it, and the script it writes back, which you read and run yourself. This repo includes a small one in mcp/ for the curious. Powerful, and it's where the safety rules matter most.

If your module is in a public GitHub repo, GitMCP (gitmcp.io/owner/repo) lets an agent search it. It reads your code; it doesn't run it. Public repos only: don't publish district code just to try it.
-->

---

# Make your module AI-ready

<div class="ready grid grid-cols-[0.9fr_1.1fr] gap-6 mt-2 items-start">
<div class="steps stagger">
  <div><span>1</span><div><b>Make it accessible</b><p>Installed on your machine, or open in VS Code</p></div></div>
  <div><span>2</span><div><b>Add an instructions file</b><p>Tell it: <code>Get-Command</code> and <code>Get-Help</code> first</p></div></div>
  <div><span>3</span><div><b>Write help comments</b><p><code>.SYNOPSIS</code> <code>.PARAMETER</code> <code>.EXAMPLE</code></p></div></div>
</div>
<div>

<p class="term-label">.github/copilot-instructions.md</p>

```markdown
Use our MultiverSIS module.

- Run Get-Command -Module MultiverSIS first.
- Check Get-Help before using a command.
- Use our functions. Don't invent new ones.
- Show the -WhatIf version first.
- Ask before changing data.
```

</div>
</div>

<p class="mt-4 text-xl text-center">The help you wrote for humans in Act II <b>works for robots too.</b></p>

<style>
.ready { --slidev-code-font-size: 15px; --slidev-code-line-height: 24px; }
.steps { display: grid; gap: 12px; }
.steps > div { display: flex; gap: 14px; align-items: center; }
.steps span { flex: none; display: grid; place-items: center; width: 38px; height: 38px; border-radius: 50%; background: var(--portal-deep); color: #f3ffe6; font-weight: 900; font-size: 1.1rem; }
.steps b { font-size: 1.3rem; color: var(--portal-light); }
.steps p { margin: 0; font-size: 1.1rem; color: var(--lab-muted); }
</style>

<!--
[36:15] Three steps. None of them needs anything new installed.

1. Make it findable. An agent that can run commands only needs the module installed on your machine: it runs Get-Command and Get-Help, like you did in Act I. The module doesn't have to live in your project. What the agent can't do is guess that it exists, which is what step 2 is for. (Opening the module's folder in VS Code also works, and lets the agent read the source. That's for when you're working on the module itself.)
2. An instructions file is a plain Markdown file the agent reads every time. Name your module in it. Copilot reads .github/copilot-instructions.md, Claude Code reads CLAUDE.md, Codex reads AGENTS.md. Same idea, different file name. This repo's is on the right, trimmed. The first two lines are the important ones: the agent can run Get-Command and Get-Help itself, so tell it to, and it uses real parameter names instead of guessing.
3. Comment-based help. The same .SYNOPSIS, .PARAMETER, and .EXAMPLE you wrote in Act II is what the agent reads. ValidateSet tells it the only allowed values.

Callback: the three commands from minute three are how the robot learns your module, too.
-->

---

# Just because you can...

<div class="grid grid-cols-[1.2fr_1fr] gap-8 mt-2">
<div>

- Start **read-only**
- Test on **fake data**
- Give it a **limited API key**
- Or its **own small module**
- Changes: **-WhatIf** first
- A **human** approves writes
- Student data? **Approval first.**

</div>
<div class="flex flex-col gap-6">
  <StickyNote :rotate="3" color="#ffd9e2">Just because you <i>can</i> let the AI run <code>Remove-SISStudent</code> doesn't mean you should.</StickyNote>
  <StickyNote :rotate="-2">This demo is safe because the students are imaginary. Yours aren't.</StickyNote>
</div>
</div>

<!--
[37:30] This is the most important slide in Act V. Slow down here.

Reading docs is very different from handing an AI your credentials. Let it read first. Let it write only with -WhatIf and your approval. Real student data goes through your district's approval process first: FERPA, your AI policy, your data privacy agreements.

Four ways to shrink the blast radius, as leads:
- A sandbox first. If your vendor offers a test or demo environment, point the AI at that before production. That's what MultiverSIS is today.
- A limited key. If the system lets you scope an API key (read-only, or only certain records), give the AI its own key with the least access that does the job. Never your admin key.
- A module made for the AI. You decide what goes in the toolbox: build a small module with only the commands you're willing to hand over, such as the Get- commands and nothing that writes. It can't run a command that isn't there.
- Log every change. Write down what changed, from what, to what, and when. That's how you find out what happened afterward, and sometimes how you put it back.

If you do build an MCP server, the one in this repo shows the guardrails: an allowlist of commands, read-only by default, refuses ConfirmImpact High, and logs every call.
-->

---

# Your homework

<div class="homework stagger">
  <div><span>1</span><p>Pick a weekly annoyance</p></div>
  <div><span>2</span><p>Script it. Ugly is fine.</p></div>
  <div><span>3</span><p>Make it a function</p></div>
  <div><span>4</span><p>Make it output objects</p></div>
  <div><span>5</span><p>Write the help</p></div>
  <div><span>6</span><p>Module it. Tell your AI.</p></div>
</div>

<style>
.homework { display: grid; grid-template-columns: 1fr 1fr; gap: 46px 30px; margin-top: 2.6rem; font-size: 1.75rem; }
.homework > div { display: flex; gap: 14px; align-items: center; }
.homework p { margin: 0; }
.homework span { flex: none; display: grid; place-items: center; width: 48px; height: 48px; font-size: 1.5rem; border-radius: 50%; font-weight: 900; color: #0a2a0c; background: radial-gradient(circle at 40% 35%, #eaffc4, #8cff3a 60%, #2e9e1f); }
</style>

<!--
[38:15] Six steps, in order. Each one is small.

Answer the opening question out loud here: is this talk obsolete? No. AI writes good code now, so the skill moved. Read it, direct it, and build simple, solid tools that people and AI can both use.
-->

---

# Thank you!

<p class="sub">Answers may vary by dimension. Everything from today is in the repo.</p>

<div class="grid grid-cols-[auto_1fr] gap-10 mt-2 items-start">
<div class="text-center">
  <QrCode url="https://www.linkedin.com/in/jessegeron" :size="230" logo="linkedin" />
  <p class="connect">Let's connect<br><span>linkedin.com/in/jessegeron</span></p>
</div>
<div class="takeaway">

- *Learn PowerShell in a Month of Lunches*
- *Learn PowerShell Scripting in a Month of Lunches*
- **Free:** Microsoft Learn, r/PowerShell
- **Next:** Pester, for testing your code
- **Shasta UHSD modules:** <a href="https://github.com/suhsdit" target="_blank">github.com/suhsdit</a>, <a href="https://www.powershellgallery.com/profiles/jgeron-suhsd" target="_blank">PSGallery</a>

</div>
</div>

<style>
.sub { margin-top: -0.6rem; color: var(--lab-muted); font-size: 1.25rem; }
.takeaway { font-size: 1rem; margin-top: 1rem; }
.connect { margin-top: 0.8rem; font-size: 1.3rem; font-weight: 800; line-height: 1.3; color: var(--portal-light); }
.connect span { font-family: 'JetBrains Mono Variable', monospace; font-size: 1.05rem; font-weight: 500; color: var(--lab-text); }
.takeaway em { color: var(--portal-light); }
</style>

<!--
[39:00] Leave this up during questions. The QR code goes to your LinkedIn profile. The repo address is at the bottom of the slide, and its README has links for every book and resource.

The last bullet: real modules you wrote at your previous district, Shasta UHSD, and published under the district. SPSAeries (the Aeries SIS API), SPSFreshService, SPSMonday, SPSImmyBot, and SPSAeriesAssetSync, which syncs Chromebooks between Google and Aeries: the real-life version of today's pipeline. They're on GitHub at github.com/suhsdit and on the PowerShell Gallery; both links are in the README.

The "Month of Lunches" books are the classic path: one short chapter a day. Pester (pester.dev) is PowerShell's testing framework: you write small tests that prove your functions still work. It's especially useful with AI-assisted coding, because the tests check the AI's work for you.
-->
