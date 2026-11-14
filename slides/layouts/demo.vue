<!-- "Live demo" slide: a spinning warning beacon, where the demo lives, and what to watch for. -->
<script setup lang="ts">
defineProps<{ file?: string }>()
</script>

<template>
  <div class="slidev-layout demo">
    <div class="beacon" aria-hidden="true">
      <div class="beam" />
      <div class="bulb" />
    </div>
    <div class="live">Live demo</div>
    <code v-if="file" class="run">{{ file }}</code>
    <div class="body">
      <slot />
    </div>
  </div>
</template>

<style scoped>
.demo {
  position: relative;
  height: 100%;
  padding: 2.4rem 3.5rem;
  overflow: hidden;
}

.live {
  font-family: var(--font-title);
  font-size: 3.6rem;
  line-height: 1;
  color: var(--amber);
  text-shadow: 0 3px 0 #4a2e00;
  animation: flicker 3s infinite;
}

.run {
  display: inline-block;
  margin-top: 0.8rem;
  font-size: 1rem !important;
}

.body {
  margin-top: 1.4rem;
  max-width: 68%;
}

.beacon {
  position: absolute;
  top: 34px;
  right: 60px;
  width: 120px;
  height: 120px;
}

.bulb {
  position: absolute;
  inset: 34px;
  border-radius: 50%;
  background: radial-gradient(circle at 40% 35%, #fff4cf, #ffb627 55%, #a86400);
  box-shadow: 0 0 30px 8px rgba(255, 182, 39, 0.7);
}

.beam {
  position: absolute;
  inset: -140px;
  border-radius: 50%;
  background: conic-gradient(from 0deg, rgba(255, 182, 39, 0.4), transparent 22%, transparent 50%, rgba(255, 182, 39, 0.4) 72%, transparent);
  -webkit-mask: radial-gradient(closest-side, #000 20%, transparent 100%);
  mask: radial-gradient(closest-side, #000 20%, transparent 100%);
  animation: spin 1.6s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes flicker {
  0%, 92%, 100% { opacity: 1; }
  94% { opacity: 0.55; }
  96% { opacity: 1; }
  97% { opacity: 0.7; }
}
</style>
