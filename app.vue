<script setup lang="ts">
import { myriad, rgbStrippedFormat } from "@myriadjs/core"
import "./style.css"

onMounted(() => myriad({
  background: '#f9ffff',
  foreground: '#0c0915',
  accents: ['#ab57ff'],
}).apply(undefined, rgbStrippedFormat))
</script>


<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
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
</style>