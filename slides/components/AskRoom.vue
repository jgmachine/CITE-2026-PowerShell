<!-- "Ask the room" callout: marks a moment to pause and get the audience talking. -->
<template>
  <div class="ask">
    <div class="i-ph-hand-palm-duotone icon" />
    <div>
      <div class="label">Ask the room</div>
      <div class="q"><slot /></div>
    </div>
  </div>
</template>

<style scoped>
.ask {
  display: inline-flex;
  align-items: center;
  gap: 14px;
  padding: 12px 20px 12px 16px;
  border: 2px solid var(--amber);
  border-radius: 14px;
  background: rgba(255, 182, 39, 0.1);
}

.icon {
  flex: none;
  font-size: 2.4rem;
  color: var(--amber);
}

.label {
  font-family: var(--font-marker);
  font-size: 1rem;
  color: var(--amber);
}

.q {
  font-size: 1.35rem;
  font-weight: 800;
  color: var(--lab-text);
  line-height: 1.3;
}
</style>
