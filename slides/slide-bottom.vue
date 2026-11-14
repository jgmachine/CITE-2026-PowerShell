<!-- Small lab-label footer on content slides. Hidden on the title, act, and closing slides. -->
<template>
  <footer v-if="!['title', 'act', 'end'].includes($frontmatter.layout)" class="lab-footer">
    <span>From Scripts to Systems</span>
    <span class="sep">•</span>
    <span>CITE 2026</span>
    <span class="repo">{{ $slidev.themeConfigs.repo.replace('https://', '') }}</span>
    <span class="page">{{ $page }}</span>
  </footer>
</template>

<style scoped>
.lab-footer {
  position: absolute;
  left: 3.5rem;
  right: 1.6rem;
  bottom: 0.9rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.78rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: rgba(157, 191, 177, 0.55);
  pointer-events: none;
}

.sep {
  color: var(--portal-deep);
}

.repo {
  margin-left: auto;
  font-family: 'JetBrains Mono Variable', monospace;
  font-size: 0.9rem;
  letter-spacing: 0;
  text-transform: none;
  color: rgba(214, 255, 196, 0.8);
}

.page {
  margin-left: 1.2rem;
  font-family: 'JetBrains Mono Variable', monospace;
  color: rgba(140, 255, 58, 0.6);
}
</style>
