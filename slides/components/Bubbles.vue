<script setup lang="ts">
// Slow bubbles rising behind the content. Fixed "random" values so every screen shows the same thing.
const bubbles = Array.from({ length: 18 }, (_, i) => ({
  left: (i * 37) % 100,
  size: 6 + ((i * 7) % 16),
  duration: 7 + ((i * 3) % 7),
  delay: -(i * 1.3),
}))
</script>

<template>
  <div class="bubbles" aria-hidden="true">
    <span
      v-for="(bubble, i) in bubbles"
      :key="i"
      :style="{
        left: `${bubble.left}%`,
        width: `${bubble.size}px`,
        height: `${bubble.size}px`,
        animationDuration: `${bubble.duration}s`,
        animationDelay: `${bubble.delay}s`,
      }"
    />
  </div>
</template>

<style scoped>
.bubbles {
  position: absolute;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
  z-index: 0;
}

span {
  position: absolute;
  bottom: -30px;
  border-radius: 50%;
  border: 1.5px solid rgba(160, 255, 90, 0.4);
  background: radial-gradient(circle at 30% 30%, rgba(230, 255, 200, 0.35), rgba(140, 255, 58, 0.05) 60%);
  animation: up linear infinite;
}

@keyframes up {
  from { transform: translate(0, 0); opacity: 0.9; }
  50% { transform: translate(12px, -300px); }
  to { transform: translate(-6px, -640px); opacity: 0; }
}
</style>
