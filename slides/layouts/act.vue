<!-- Section divider for each act: goo drips from the top, a portal swirls on the right. -->
<script setup lang="ts">
defineProps<{ act?: string, kicker?: string }>()
</script>

<template>
  <div class="slidev-layout act">
    <Bubbles />
    <Goo />
    <div class="text">
      <div class="kicker">{{ kicker ?? `Act ${act}` }}</div>
      <slot />
    </div>
    <div class="portal-wrap">
      <Portal :size="230" />
    </div>
    <RepoCard class="repo" :size="92" />
  </div>
</template>

<style scoped>
.act {
  position: relative;
  display: grid;
  grid-template-columns: 2fr 1fr;
  align-items: center;
  gap: 2rem;
  height: 100%;
  padding: 3rem 3.5rem 2rem;
  overflow: hidden;
}

.text {
  position: relative;
  z-index: 2;
}

.repo {
  position: absolute;
  right: 1.6rem;
  bottom: 1.2rem;
  z-index: 3;
}

.kicker {
  display: inline-block;
  margin-bottom: 0.3rem;
  font-family: var(--font-marker);
  font-size: 1.5rem;
  letter-spacing: 0.05em;
  color: var(--amber);
  transform: rotate(-2deg);
}

.act :deep(h1) {
  margin: 0 0 1rem;
  font-size: 4.1rem;
  line-height: 1;
}

.act :deep(p) {
  margin: 0;
  font-size: 1.35rem;
  line-height: 1.55;
  color: var(--lab-muted);
  opacity: 1;
}

.portal-wrap {
  position: relative;
  z-index: 1;
  display: grid;
  place-items: center;
}
</style>
