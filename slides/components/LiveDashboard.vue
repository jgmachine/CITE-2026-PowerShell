<script setup lang="ts">
import { onMounted, ref } from 'vue'

// Shows the live MultiverSIS dashboard when the server is running on this laptop,
// and a screenshot when it isn't (for example, when the deck is viewed on GitHub Pages).
const props = withDefaults(defineProps<{ url?: string, scale?: number }>(), {
  url: 'http://localhost:8080',
  scale: 0.42,
})
const live = ref(false)
const screenshot = `${import.meta.env.BASE_URL}dashboard.png`

onMounted(async () => {
  try {
    await fetch(`${props.url}/health`, { mode: 'no-cors', cache: 'no-store' })
    live.value = true
  }
  catch {
    live.value = false
  }
})
</script>

<template>
  <div class="frame">
    <div class="bar">
      <i /><i /><i />
      <span>{{ props.url }}</span>
      <b v-if="live" class="live">● LIVE</b>
      <b v-else class="shot">screenshot</b>
    </div>
    <div class="viewport">
      <iframe
        v-if="live"
        :src="props.url"
        title="MultiverSIS dashboard"
        :style="{ transform: `scale(${props.scale})`, width: `${100 / props.scale}%`, height: `${100 / props.scale}%` }"
      />
      <img v-else :src="screenshot" alt="The MultiverSIS dashboard, full of Ricks">
    </div>
  </div>
</template>

<style scoped>
.frame {
  overflow: hidden;
  border: 1px solid #2c6a3f;
  border-radius: 12px;
  background: #06100d;
  box-shadow: 0 0 34px rgba(140, 255, 58, 0.2);
}

.bar {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 8px 12px;
  border-bottom: 1px solid #173a26;
  font-family: 'JetBrains Mono Variable', monospace;
  font-size: 0.82rem;
  color: var(--lab-muted);
}

.bar i {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: #ff5f57;
}

.bar i:nth-child(2) { background: #febc2e; }
.bar i:nth-child(3) { background: #28c840; }

.bar span {
  margin-left: 6px;
}

.bar b {
  margin-left: auto;
  font-size: 0.78rem;
  letter-spacing: 0.1em;
}

.live { color: var(--portal); }
.shot { color: var(--lab-muted); }

.viewport {
  position: relative;
  height: 290px;
  overflow: hidden;
}

iframe {
  position: absolute;
  top: 0;
  left: 0;
  border: 0;
  transform-origin: 0 0;
}

img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: top left;
}
</style>
