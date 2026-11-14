<!-- "Get the slides and code": a QR code and the repo address, for the title and act slides. -->
<script setup lang="ts">
withDefaults(defineProps<{ size?: number }>(), { size: 150 })
</script>

<template>
  <!-- Text and padding scale with the QR size, so a smaller card stays in proportion. -->
  <div class="repo-card" :style="{ fontSize: `${size / 150}rem` }">
    <QrCode :url="$slidev.themeConfigs.repo" :size="size" />
    <div class="words">
      <b>Slides + code</b>
      <span>{{ $slidev.themeConfigs.repo.replace('https://', '').replace(/\/[^/]+$/, '/') }}</span>
      <span>{{ $slidev.themeConfigs.repo.split('/').pop() }}</span>
    </div>
  </div>
</template>

<style scoped>
.repo-card {
  display: flex;
  align-items: center;
  gap: 0.9em;
  padding: 0.7em 1em 0.7em 0.7em;
  border: 2px solid var(--portal-deep);
  border-radius: 18px;
  background: rgba(6, 16, 13, 0.92);
}

.words b {
  display: block;
  font-size: 1.5em;
  line-height: 1.2;
  color: var(--portal);
}

.words span {
  display: block;
  margin-top: 2px;
  white-space: nowrap;
  font-family: 'JetBrains Mono Variable', monospace;
  font-size: 1.05em;
  line-height: 1.3;
  color: var(--lab-text);
}
</style>
