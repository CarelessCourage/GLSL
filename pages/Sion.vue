<script setup lang="ts">
import { Vector3 } from 'three'
import foldVertex from '../shaders/sion/vertex.glsl'
import foldFragment from '../shaders/sion/fragment.glsl'

const subdivisions = ref(260)
const blur = ref(0.001)
const size = ref(0.4)
const x = ref(0.0)
const y = ref(0.0)

const circles = ref([
  new Vector3( x.value - 0.2, y.value + 0.2, size.value ),
  new Vector3( x.value, y.value, size.value ),
  new Vector3( x.value + 0.2, y.value + -0.2, size.value ),
  new Vector3( 0.0, 0.0, 0.0 ),
  new Vector3( 0.0, 0.0, 0.0 ),
  new Vector3( 0.0, 0.0, 0.0 ),
  new Vector3( 0.0, 0.0, 0.0 ),
  new Vector3( 0.0, 0.0, 0.0 ),
  new Vector3( 0.0, 0.0, 0.0 ),
  new Vector3( 0.0, 0.0, 0.0 )
])

watch([size, x, y], () => {
  circles.value[0].setX(x.value)
  circles.value[0].setY(y.value)
  circles.value[0].setZ(size.value)
})

function clamp(value: number, min: number, max: number) {
  return Math.min(Math.max(value, min), max)
}

function randomizeCircles(amount: number) {
  for (let i = 0; i < amount; i++) {
    circles.value[i].setX(Math.random() * 2.0 - 1.0)
    circles.value[i].setY(Math.random() * 2.0 - 1.0)
    circles.value[i].setZ(clamp(Math.random() / 2.0, 0.005, 0.4))
  }
}

// onMounted(() => {
//   randomizeCircles(6)
// })

const meshRef = ref<any>(null)
const materialRef = ref<any>(null)
const uniforms = {
  uTime: { value: 0 },
  uBlur: { value: blur.value },
  uSeed: { value: 6.7 },
  uCircles: { value: circles.value },
}

const { onLoop, resume } = useRenderLoop()
resume()
onLoop(({ elapsed }) => {
  if (!meshRef.value) return
  meshRef.value.material.uniforms.uTime.value = elapsed
  meshRef.value.material.uniforms.uBlur.value = blur.value
  meshRef.value.material.uniforms.uCircles.value = circles.value
})
</script>

<template>
  <div class="pane">
    <p>blur: {{ blur }}</p>
    <URange v-model="blur" name="range" :min="0.001" :max="1.0" :step="0.001" />
    <p>size: {{ size }}</p>
    <URange v-model="size" name="range" :min="0.1" :max="1.0" :step="0.001" />
    <p>x: {{ x }}</p>
    <URange v-model="x" name="range" :min="-1.0" :max="1.0" :step="0.001" />
    <p>y: {{ y }}</p> 
    <URange v-model="y" name="range" :min="-1.0" :max="1.0" :step="0.001" />
    <UButton @click="() => randomizeCircles(6)">Rand</UButton>
  </div>
  <div class="tres">
    <TresCanvas clear-color="#111" shadows alpha :windowSize="true">
      <TresPerspectiveCamera :position="[0, 0, 11]" />
      <!-- <OrbitControls /> -->
      <TresMesh v-if="true" ref="meshRef" :position="[0, 0, 0]">
        <TresPlaneGeometry :args="[10, 10, subdivisions, subdivisions]" />   
        <TresShaderMaterial
          ref="materialRef"
          :vertex-shader="foldVertex"
          :fragment-shader="foldFragment"
          :uniforms="uniforms"
        />
      </TresMesh>
    </TresCanvas>
  </div>
</template>

<style>
.pane {
  position: absolute;
  bottom: 0px;
  width: 20rem;
  padding: var(--space);
  border-radius: var(--space);
  background-color: rgb(var(--background, 255, 255, 255));
}
</style>