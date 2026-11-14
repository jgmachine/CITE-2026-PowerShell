<script setup lang="ts">
import { useId } from 'vue'

// Slime oozing down from the top of the slide. The SVG "goo" filter blurs the shapes
// together and sharpens the edges again, so the drips look like one blob of slime.
const id = useId()
const drips = [
  { x: 55, w: 26, h: 62, delay: 0 },
  { x: 165, w: 18, h: 40, delay: 1.2 },
  { x: 290, w: 34, h: 88, delay: 0.4 },
  { x: 425, w: 20, h: 50, delay: 2.1 },
  { x: 555, w: 28, h: 74, delay: 0.9 },
  { x: 690, w: 16, h: 36, delay: 1.7 },
  { x: 795, w: 30, h: 94, delay: 0.2 },
  { x: 915, w: 22, h: 56, delay: 1.4 },
]
</script>

<template>
  <svg class="goo" viewBox="0 0 1000 140" preserveAspectRatio="none" aria-hidden="true">
    <defs>
      <filter :id="`goo-${id}`">
        <feGaussianBlur in="SourceGraphic" stdDeviation="7" result="blur" />
        <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 24 -10" />
      </filter>
      <linearGradient :id="`slime-${id}`" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#cfff84" />
        <stop offset="100%" stop-color="#3fbf1f" />
      </linearGradient>
    </defs>
    <g :filter="`url(#goo-${id})`" :fill="`url(#slime-${id})`">
      <rect x="-20" y="-10" width="1040" height="32" />
      <template v-for="drip in drips" :key="drip.x">
        <rect
          class="drip"
          :x="drip.x"
          y="8"
          :width="drip.w"
          :height="drip.h"
          :rx="drip.w / 2"
          :style="{ animationDelay: `${drip.delay}s` }"
        />
        <circle
          class="drop"
          :cx="drip.x + drip.w / 2"
          :cy="drip.h + 2"
          :r="drip.w / 2.5"
          :style="{ animationDelay: `${drip.delay}s` }"
        />
      </template>
    </g>
  </svg>
</template>

<style scoped>
.goo {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 118px;
  pointer-events: none;
  z-index: 5;
  filter: drop-shadow(0 4px 12px rgba(140, 255, 58, 0.35));
}

.drip {
  transform-box: fill-box;
  transform-origin: top;
  animation: ooze 4.5s ease-in-out infinite;
}

.drop {
  transform-box: fill-box;
  opacity: 0;
  animation: fall 4.5s ease-in infinite;
}

@keyframes ooze {
  0%, 100% { transform: scaleY(0.5); }
  50% { transform: scaleY(1); }
}

@keyframes fall {
  0%, 44% { opacity: 0; transform: translateY(0); }
  50% { opacity: 1; }
  100% { opacity: 0; transform: translateY(80px); }
}
</style>
