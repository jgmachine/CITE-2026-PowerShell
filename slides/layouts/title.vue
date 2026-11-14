<!--
  The title art, brought to life: the portal glows and swirls, sparks drift out of it,
  the goo puddle pulses, and the laptop cursor blinks. Positions are percentages of the
  1672x941 image (the same 16:9 shape as the slide).
-->
<template>
  <div class="slidev-layout title-art">
    <img class="art" src="/titledeck.png" alt="From Scripts to Systems: Building Reusable PowerShell Tools for District IT. CITE Annual Conference 2026.">
    <div class="portal-swirl" />
    <div class="portal-glow" />
    <div class="puddle-glow" />
    <div class="cursor" />
    <span v-for="i in 10" :key="i" class="mote" :style="{ '--i': i }" />
    <div class="content">
      <slot />
    </div>
  </div>
</template>

<style scoped>
.title-art {
  position: relative;
  padding: 0;
  overflow: hidden;
  background: #000;
}

.art {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* The portal in the art is centered around (78%, 35%). */
.portal-glow {
  position: absolute;
  left: 78%;
  top: 35%;
  width: 30%;
  height: 58%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  background: radial-gradient(closest-side, rgba(170, 255, 90, 0.5), rgba(140, 255, 58, 0.18) 60%, transparent);
  mix-blend-mode: screen;
  animation: pulse 3.2s ease-in-out infinite;
  pointer-events: none;
}

.portal-swirl {
  position: absolute;
  left: 78%;
  top: 35%;
  width: 26%;
  height: 50%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  background: repeating-conic-gradient(from 0deg, rgba(220, 255, 160, 0.55) 0deg 8deg, transparent 8deg 30deg);
  -webkit-mask: radial-gradient(closest-side, transparent 72%, #000 80%, #000 94%, transparent 100%);
  mask: radial-gradient(closest-side, transparent 72%, #000 80%, #000 94%, transparent 100%);
  mix-blend-mode: overlay;
  filter: blur(2px);
  animation: swirl 9s linear infinite;
  pointer-events: none;
}

/* The glowing goo puddle, bottom center-left */
.puddle-glow {
  position: absolute;
  left: 28.5%;
  top: 93.5%;
  width: 15%;
  height: 9%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  background: radial-gradient(closest-side, rgba(150, 255, 70, 0.55), transparent);
  mix-blend-mode: screen;
  animation: pulse 2.4s ease-in-out infinite;
  pointer-events: none;
}

/* The "PS C:\>" cursor on the laptop screen */
.cursor {
  position: absolute;
  left: 41.89%;
  top: 62.81%;
  width: 0.72%;
  height: 2.13%;
  background: #d9ffd0;
  box-shadow: 0 0 8px rgba(160, 255, 120, 0.9);
  animation: blink 1.05s steps(2, start) infinite;
  pointer-events: none;
}

.mote {
  position: absolute;
  left: 78%;
  top: 35%;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: #eaffc7;
  box-shadow: 0 0 10px 3px rgba(140, 255, 58, 0.85);
  opacity: 0;
  animation: drift 6s ease-out infinite;
  animation-delay: calc(var(--i) * -0.6s);
  pointer-events: none;
}

.content {
  position: absolute;
  inset: 0;
}

@keyframes pulse {
  50% { opacity: 0.55; transform: translate(-50%, -50%) scale(1.06); }
}

@keyframes swirl {
  to { transform: translate(-50%, -50%) rotate(360deg); }
}

@keyframes blink {
  to { visibility: hidden; }
}

@keyframes drift {
  0% { transform: translate(0, 0) scale(0.5); opacity: 0; }
  15% { opacity: 1; }
  100% {
    transform: translate(calc((var(--i) - 5.5) * 26px), calc(-140px + var(--i) * 22px)) scale(1);
    opacity: 0;
  }
}
</style>
