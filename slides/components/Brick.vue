<script setup lang="ts">
withDefaults(defineProps<{ color?: string, studs?: number, sub?: string }>(), { color: '#8cff3a', studs: 4 })
</script>

<template>
  <div class="brick" :style="{ '--brick': color }">
    <div class="studs">
      <span v-for="i in studs" :key="i" />
    </div>
    <div class="body">
      <div class="label"><slot /></div>
      <div v-if="sub" class="sub"><div v-for="part in sub.split(' · ')" :key="part">{{ part }}</div></div>
    </div>
  </div>
</template>

<style scoped>
.brick {
  display: inline-flex;
  flex-direction: column;
  min-width: 150px;
}

.studs {
  display: flex;
  justify-content: space-evenly;
  height: 11px;
  padding: 0 12px;
}

.studs span {
  width: 22px;
  height: 11px;
  border-radius: 5px 5px 0 0;
  background: linear-gradient(180deg, color-mix(in srgb, var(--brick), white 30%), var(--brick));
  box-shadow: inset 0 -2px 0 rgba(0, 0, 0, 0.2);
}

.body {
  padding: 11px 14px;
  border-radius: 6px;
  background: linear-gradient(180deg, var(--brick), color-mix(in srgb, var(--brick), black 25%));
  box-shadow:
    inset 0 2px 0 rgba(255, 255, 255, 0.35),
    inset 0 -4px 0 rgba(0, 0, 0, 0.25),
    0 8px 18px rgba(0, 0, 0, 0.45);
  color: #07130e;
  text-align: center;
}

.label {
  font-weight: 900;
  font-size: 1rem;
  line-height: 1.2;
}

.sub {
  font-size: 1rem;
  font-weight: 700;
  opacity: 0.8;
}
</style>
