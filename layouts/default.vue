<script setup lang="ts">
const shaders = [
  //{label: 'Light', icon: 'i-heroicons-sun', url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/SDF.vue'},
  {label: 'Impact', icon: 'i-heroicons-sparkles', path: "/impact", url: 'https://github.com/CarelessCourage/GLSL/blob/main/pages/impact.vue'},
  {label: 'Evolve', icon: 'i-heroicons-moon', path: "/spiral", url: 'https://github.com/CarelessCourage/GLSL/blob/main/pages/Spiral.vue'},
  //{label: 'Refraction', icon: 'i-heroicons-cube-transparent', path: "/refraction", url: 'https://github.com/CarelessCourage/GLSL/blob/main/components/Spiral.vue'},
  {label: 'Jonah', icon: 'i-heroicons-finger-print', path: "/folds", url: 'https://github.com/CarelessCourage/GLSL/blob/main/pages/Folds.vue'},
  {label: 'SDF', icon: 'i-heroicons-variable', path: "/sdf", url: 'https://github.com/CarelessCourage/GLSL/blob/main/pages/SDF.vue'},
  {label: 'Chrome', icon: 'i-heroicons-cube-transparent', path: "/chrome", url: 'https://github.com/CarelessCourage/GLSL/blob/main/pages/Chrome.vue'},
  {label: 'Experiment', icon: 'i-heroicons-code-bracket-square', path: "/experiment", url: 'https://github.com/CarelessCourage/GLSL/blob/main/pages/Experiment.vue'},
]

const selected = ref(shaders[0])
const route = useRoute()

onMounted(() => {
  const path = route.path
  if(path !== '/') return
  navigateTo({
    path: selected.value.path,
  })
})

watch(selected, (val) => {
  navigateTo({
    path: val.path,
  })
})
</script>


<template>
  <slot />
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
</template>


<style>
.meta-island {
  position: absolute;
  bottom: var(--space);
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
  min-width: 10rem;
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
</style>
