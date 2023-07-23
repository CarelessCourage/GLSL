// App.vue
<script setup lang="ts">
import { myriad } from "@myriadjs/core"
import "./style.css"

onMounted(() => myriad({
  background: '#c0aea3',
  foreground: '#0c0915',
  accents: ['#ab57ff'],
}).apply())

const people = ['Evolve', 'Impact', 'Cancer', 'Jonah']
const selected = ref(people[0])
</script>

<template>
  <div  class="tres">
    <Spiral v-if="selected === 'Evolve'" />
    <SDF v-if="selected === 'Impact'" />
    <Folds v-if="selected === 'Cancer'" />
    <Folds v-if="selected === 'Jonah'" :zoom="0.5"/>

    <div class="meta-island">
      <div class="github">github</div>
      <USelectMenu v-model="selected" :options="people" />
    </div>
  </div>
</template>


<style>
.meta-island {
  display: flex;
  gap: var(--space-s);

  position: absolute;
  bottom: 0;
  right: 0;

  background-color: var(--background);

  padding: 1rem;
  display: flex;
  flex-direction: column;
  align-items: flex-start;

  min-width: 20rem;
  border-radius: var(--radius);

  justify-content: flex-start;
  z-index: 999;
}
</style>