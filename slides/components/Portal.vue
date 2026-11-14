<script setup lang="ts">
const props = withDefaults(defineProps<{ size?: number }>(), { size: 300 })
</script>

<template>
  <div class="portal" :style="{ '--size': `${props.size}px` }" aria-hidden="true">
    <div class="glow" />
    <div class="ring outer" />
    <div class="ring inner" />
    <div class="core" />
    <span v-for="i in 14" :key="i" class="spark" :style="{ '--i': i }" />
  </div>
</template>

<style scoped>
.portal {
  position: relative;
  width: var(--size);
  height: var(--size);
}

.glow {
  position: absolute;
  inset: -22%;
  border-radius: 50%;
  background: radial-gradient(closest-side, rgba(140, 255, 58, 0.5), rgba(140, 255, 58, 0.12) 55%, transparent);
  animation: breathe 5s ease-in-out infinite;
}

.ring {
  position: absolute;
  border-radius: 50%;
}

.ring.outer {
  inset: 0;
  background: repeating-conic-gradient(from 0deg, #e2ffa8 0deg 10deg, #4ccb2b 10deg 27deg, #aaff52 27deg 41deg, #257f18 41deg 60deg);
  filter: blur(5px);
  -webkit-mask: radial-gradient(closest-side, transparent 60%, #000 70%, #000 90%, transparent 100%);
  mask: radial-gradient(closest-side, transparent 60%, #000 70%, #000 90%, transparent 100%);
  animation: spin 45s linear infinite;
}

.ring.inner {
  inset: 9%;
  background: repeating-conic-gradient(from 25deg, #f5ffd9 0deg 9deg, #6fe83b 9deg 26deg, #1c6f12 26deg 40deg);
  filter: blur(3.5px);
  opacity: 0.9;
  -webkit-mask: radial-gradient(closest-side, transparent 58%, #000 68%, #000 90%, transparent 100%);
  mask: radial-gradient(closest-side, transparent 58%, #000 68%, #000 90%, transparent 100%);
  animation: spin 35s linear infinite reverse;
}

.core {
  position: absolute;
  inset: 25%;
  border-radius: 50%;
  background: radial-gradient(circle at 50% 42%, #fbfff2 0%, #d6ff9a 20%, #7eea40 50%, #1c6112 100%);
  box-shadow: 0 0 55px 18px rgba(140, 255, 58, 0.55), inset 0 0 40px rgba(0, 50, 0, 0.55);
  animation: breathe 5s ease-in-out infinite;
}

.spark {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 7px;
  height: 7px;
  margin: -3.5px;
  border-radius: 50%;
  background: #eaffc7;
  box-shadow: 0 0 12px 3px rgba(140, 255, 58, 0.9);
  opacity: 0;
  animation: orbit 10s linear infinite;
  animation-delay: calc(var(--i) * -0.72s);
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes breathe {
  50% { transform: scale(0.96); }
}

/* Slow, no brightness flashing. Fully still for anyone who asks their OS for less motion. */
@media (prefers-reduced-motion: reduce) {
  .glow, .ring, .core, .spark { animation: none; }
}

@keyframes orbit {
  0% { transform: rotate(calc(var(--i) * 26deg)) translateX(calc(var(--size) * 0.3)) scale(0.4); opacity: 0; }
  20% { opacity: 1; }
  100% { transform: rotate(calc(var(--i) * 26deg + 300deg)) translateX(calc(var(--size) * 0.66)) scale(1); opacity: 0; }
}
</style>
