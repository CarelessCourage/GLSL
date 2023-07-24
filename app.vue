// App.vue
<script setup lang="ts">
import { myriad, rgbStrippedFormat } from "@myriadjs/core"
import "./style.css"

onMounted(() => myriad({
  background: '#c0aea3',
  foreground: '#0c0915',
  accents: ['#ab57ff'],
}).apply(undefined, rgbStrippedFormat))

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
.tres {
  --color-primary-50: var(--accent);
  --color-primary-100: var(--accent);
  --color-primary-200: var(--accent-10);
  --color-primary-300: var(--accent-20);
  --color-primary-400: var(--accent-30);
  --color-primary-500: var(--accent-30);
  --color-primary-600: var(--accent-40);
  --color-primary-700: var(--accent-50);
  --color-primary-800: var(--accent-60);
  --color-primary-900: var(--accent-contrast);
  --color-primary-950: var(--accent-contrast);


  --color-gray-50: var(--background);
  --color-gray-100: var(--background);
  --color-gray-200: var(--background-10);
  --color-gray-300: var(--background-20);
  --color-gray-400: var(--background-30);
  --color-gray-500: var(--background-30);
  --color-gray-600: var(--foreground-30);
  --color-gray-700: var(--foreground-20);
  --color-gray-800: var(--foreground-10);
  --color-gray-900: var(--foreground);
  --color-gray-950: var(--foreground);
}


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