<script setup lang="ts">
import QRCode from 'qrcode'
import { ref, watchEffect } from 'vue'

// Drawn locally (no QR web service), so it works offline.
// `logo` puts a small badge in the middle so people know what they're scanning. The code is then
// drawn with the highest error correction, which is what lets it scan with its center covered.
const props = withDefaults(defineProps<{ url: string, size?: number, logo?: 'linkedin' }>(), { size: 220 })
const svg = ref('')

watchEffect(async () => {
  svg.value = await QRCode.toString(props.url, {
    type: 'svg',
    margin: 1,
    errorCorrectionLevel: props.logo ? 'H' : 'M',
    color: { dark: '#06120d', light: '#eaffd6' },
  })
})
</script>

<template>
  <div class="qr" :style="{ width: `${props.size}px`, height: `${props.size}px` }">
    <div class="code" v-html="svg" />
    <div v-if="props.logo === 'linkedin'" class="logo" aria-hidden="true"><div class="i-ph-linkedin-logo-fill" /></div>
  </div>
</template>

<style scoped>
.qr {
  padding: 10px;
  border-radius: 14px;
  background: #eaffd6;
  box-shadow: 0 0 0 3px var(--portal-deep), 0 0 36px rgba(140, 255, 58, 0.45);
}

.qr { position: relative; }

.code { width: 100%; height: 100%; }

.logo {
  position: absolute;
  left: 50%;
  top: 50%;
  display: grid;
  place-items: center;
  width: 24%;
  height: 24%;
  transform: translate(-50%, -50%);
  border-radius: 18%;
  background: #eaffd6;
  color: #0a66c2;
}

.logo > div { width: 100%; height: 100%; }

.qr :deep(svg) {
  width: 100%;
  height: 100%;
  display: block;
}
</style>
