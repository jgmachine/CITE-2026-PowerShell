<script setup lang="ts">
withDefaults(defineProps<{ rotate?: number, color?: string }>(), { rotate: -3, color: '#f3e6c8' })
</script>

<template>
  <div class="note" :style="{ transform: `rotate(${rotate}deg)`, background: color }">
    <div class="tape" />
    <slot />
  </div>
</template>

<style scoped>
.note {
  position: relative;
  padding: 18px 18px 14px;
  border-radius: 2px;
  color: var(--ink);
  font-family: var(--font-marker);
  font-size: 1.05rem;
  line-height: 1.3;
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.45);
}

.note :deep(code) {
  color: var(--ink);
  background: rgba(0, 0, 0, 0.08);
  border-color: rgba(0, 0, 0, 0.15);
}

.tape {
  position: absolute;
  top: -10px;
  left: 50%;
  width: 80px;
  height: 22px;
  margin-left: -40px;
  background: rgba(235, 235, 205, 0.6);
  transform: rotate(2deg);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}
</style>
