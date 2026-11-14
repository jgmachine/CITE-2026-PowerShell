<!-- A small "go to the demo now" marker for slides that don't use the full Live demo layout. -->
<script setup lang="ts">
// place="bottom" moves the marker to the bottom-left, for slides whose top-right corner is taken.
withDefaults(defineProps<{ place?: 'top' | 'bottom' }>(), { place: 'top' })
</script>

<template>
  <div class="demo-cue" :class="place">
    <div class="i-ph-play-circle-duotone icon" />
    <div><b>Demo</b><span><slot /></span></div>
  </div>
</template>

<style scoped>
.demo-cue {
  position: absolute;
  top: 2.5rem;
  right: 3.5rem;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 16px 6px 10px;
  border: 2px solid var(--amber);
  border-radius: 999px;
  background: rgba(255, 182, 39, 0.1);
}

.demo-cue.bottom {
  top: auto;
  right: auto;
  left: 3.5rem;
  bottom: 2.9rem;
  padding: 2px 14px 2px 8px;
}

.icon {
  flex: none;
  font-size: 2rem;
  color: var(--amber);
}

b {
  margin-right: 8px;
  font-family: var(--font-marker);
  font-size: 1.15rem;
  color: var(--amber);
}

span {
  font-family: 'JetBrains Mono Variable', monospace;
  font-size: 1rem;
  color: var(--lab-text);
}
</style>
