// App.vue
<script setup lang="ts">
import { myriad, rgbStrippedFormat } from "@myriadjs/core"
import "./style.css"

onMounted(() => myriad({
  background: '#f9ffff',
  foreground: '#0c0915',
  accents: ['#ab57ff'],
}).apply(undefined, rgbStrippedFormat))

const shaders = [
  //{label: 'Experiment', icon: 'i-heroicons-code-bracket-square', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/Experiment.vue'},
  {label: 'Impact', icon: 'i-heroicons-sparkles', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/SDF.vue'},
  {label: 'Evolve', icon: 'i-heroicons-moon', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/Spiral.vue'},
  {label: 'Cancer', icon: 'i-heroicons-building-library', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/Folds.vue'},
  {label: 'Jonah', icon: 'i-heroicons-finger-print', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/Folds.vue'},
  {label: 'SDF', icon: 'i-heroicons-variable', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/SDF.vue'},
  {label: 'Chrome', icon: 'i-heroicons-cube-transparent', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/Chrome.vue'}
]
const selected = ref(shaders[0])
</script>

<template>
  <div  class="tres">
    <Spiral v-if="selected.label === 'Evolve'" />
    <Impact v-if="selected.label === 'Impact'" />
    <Folds v-if="selected.label === 'Cancer'" />
    <Folds v-if="selected.label === 'Jonah'" :zoom="0.5"/>
    <SDF v-if="selected.label === 'SDF'" />
    <Chrome v-if="selected.label === 'Chrome'" />
    <Experiment v-if="selected.label === 'Experiment'" />

    <div class="meta-island">
      <NuxtLink :to="selected.url" class="github">
        <UIcon name="i-heroicons-code-bracket-square" />
      </NuxtLink>
      <div class="controls">
        <div class="select">
          <USelectMenu v-model="selected" :options="shaders">
            <template #label>
              <UIcon v-if="selected.icon" :name="selected.icon" class="w-4 h-4" />
              {{ selected.label }}
            </template>
          </USelectMenu>
        </div>
      </div>
    </div>
  </div>
</template>


<style>
.meta-island {
  position: absolute;
  top: var(--space);
  right: var(--space);

  display: flex;
  align-items: center;

  z-index: 999;
}

.controls {
  display: flex;
  align-items: center;
  background-color: rgb(var(--background));
  color: rgb(var(--foreground));
  border-radius: var(--radius);
  height: var(--space-l);
  padding: 0px var(--space-s);
}

.controls .select li {
  cursor: pointer;
}

.controls button {
  cursor: pointer;
}

.github {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-xs);

  font-size: 2rem;

  background: rgb(var(--background-10));
  height: var(--space-l);
  padding: 0px var(--space-s);
  border-radius: var(--radius);

  transform-origin: .2s;
}

.github:hover {
  background: rgb(var(--accent));
  color: rgb(var(--background));
}

.github:active {
  background: rgb(var(--accent));
}

.github span {
  transition: .2s;
}

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
</style>