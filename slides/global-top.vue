<!-- A glowing ring that grows with the "portal" slide transition. -->
<script setup lang="ts">
import { useNav } from '@slidev/client'
import { ref, watch } from 'vue'

const { currentPage, currentTransition } = useNav()
const flash = ref(0)

watch(currentPage, () => {
  if (currentTransition.value?.name === 'portal')
    flash.value++
})
</script>

<template>
  <div v-if="flash" :key="flash" class="portal-ring" aria-hidden="true" />
</template>

<style scoped>
.portal-ring {
  position: absolute;
  left: 50%;
  top: 50%;
  z-index: 100;
  border-radius: 50%;
  transform: translate(-50%, -50%);
  box-shadow:
    0 0 0 6px #b6ff5e,
    0 0 26px 10px rgba(140, 255, 58, 0.85),
    inset 0 0 26px 10px rgba(140, 255, 58, 0.65);
  pointer-events: none;
  animation: ring 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
}

@keyframes ring {
  0% { width: 0; height: 0; opacity: 1; }
  75% { opacity: 1; }
  100% { width: 1300px; height: 1300px; opacity: 0; }
}

@media (prefers-reduced-motion: reduce) {
  .portal-ring { display: none; }
}
</style>
