// App.vue
<script setup lang="ts">
import { myriad } from "@myriadjs/core"
import "./style.css"

onMounted(() => {
  const m = myriad({
  background: '#0c0915',
  foreground: '#c0aea3',
  accents: ['#ab57ff'],
}).attach().colors

console.log(m)
})

const people = ['Wade Cooper', 'Arlene Mccoy', 'Devon Webb', 'Tom Cook', 'Tanya Fox', 'Hellen Schmidt', 'Caroline Schultz', 'Mason Heaney', 'Claudie Smitham', 'Emil Schaefer']
const selected = ref(people[0])
</script>

<template>
  <div  class="tres">
    <Spiral />

    <div class="meta-island">
      <div class="github">github</div>
      <USelectMenu v-model="selected" :options="people" />
    </div>
  </div>
</template>


<style>
.meta-island {
  position: absolute;
  top: 0;
  left: 0;

  background-color: var(--foreground);

  padding: 1rem;
  display: flex;
  flex-direction: column;
  align-items: flex-start;

  justify-content: flex-start;
  z-index: 999;
}
</style>