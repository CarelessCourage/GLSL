<script setup lang="ts">
import { Vector3, Vector2 } from 'three'
import foldVertex from '../shaders/sion/vertex.glsl'
import foldFragment from '../shaders/sion/fragment.glsl'

const subdivisions = ref(260)
const strength = ref(1.0)
const inverseStrength = computed(() => 1.0 - strength.value)
const blur = ref(0.04)
const alphaBlur = ref(0.4)
const size = ref(0.0)
const uvOrigin = ref({
  x: 0.5,
  y: 0.5,
  scale: 7.42
})
const x = ref(0.5)
const y = ref(0.5)

const offset = ref(0.3)
const offset2 = ref({
  x: 0.5,
  y: 0.5
})

const offsetLol = computed(() => {
  const lol = 0.0;
  return {
    x: offset2.value.x + lol,
    y: offset2.value.y - lol
  }
})

const circles = ref([
  new Vector3( 0.25, 0.75, 0.1 ),
  new Vector3( x.value, y.value, 0.1 ),
  new Vector3( 0.75, 0.25, 0.1 ),
  new Vector3( 0.0, 0.0, 0.1 ),
  new Vector3( 1.0, 1.0, 0.1 ),
  new Vector3( 0.0, 1.0, 0.1 ),
  new Vector3( 1.0, 0.0, 0.1 ),
  new Vector3( 0.0, 0.5, 0.1 ),
  new Vector3( 1.0, 0.5, 0.1 ),
  new Vector3( 0.0, 0.0, 0.0 )
])

watch([x, y], () => {
  circles.value[0].setX(x.value)
  circles.value[0].setY(y.value)
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
//   randomizeCircles(10)
// })

const meshRef = ref<any>(null)
const materialRef = ref<any>(null)
const uniforms = {
  uTime: { value: 0 },
  uBlur: { value: blur.value },
  uAlphaBlur: { value: alphaBlur.value },
  uSeed: { value: 6.7 },
  uCircles: { value: circles.value },
  uSize: { value: size.value },
  uStrength: { value: inverseStrength.value },
  uvOrigin: { value: new Vector3(uvOrigin.value.x, uvOrigin.value.y, uvOrigin.value.scale) },
  uOffset: { value: new Vector2(offset2.value.x, offset2.value.y) },
}

const { onLoop, resume } = useRenderLoop()
resume()
onLoop(({ elapsed }) => {
  if (!meshRef.value) return
  meshRef.value.material.uniforms.uTime.value = elapsed
  meshRef.value.material.uniforms.uBlur.value = blur.value
  meshRef.value.material.uniforms.uAlphaBlur.value = alphaBlur.value
  meshRef.value.material.uniforms.uCircles.value = circles.value
  meshRef.value.material.uniforms.uSize.value = size.value
  meshRef.value.material.uniforms.uStrength.value = inverseStrength.value
  meshRef.value.material.uniforms.uvOrigin.value = new Vector3(uvOrigin.value.x, uvOrigin.value.y, uvOrigin.value.scale),
  meshRef.value.material.uniforms.uOffset.value = new Vector2(offsetLol.value.x, offsetLol.value.y)
})
</script>

<template>
  <div class="pane">
    <div>
      <p>origin scale: {{ uvOrigin.scale }}</p>
      <URange v-model="uvOrigin.scale" name="range" :min="0.01" :max="10.0" :step="0.001" />
      <p>strength: {{ strength }}</p>
      <URange v-model="strength" name="range" :min="0.0" :max="1.0" :step="0.001" />
    </div>
    <div v-if="true">
      <p>blur: {{ blur }}</p>
      <URange v-model="blur" name="range" :min="0.001" :max="1.0" :step="0.001" />
      <p>alpha blur: {{ alphaBlur }}</p>
      <URange v-model="alphaBlur" name="range" :min="0.001" :max="1.0" :step="0.001" />
    </div>
    <UButton @click="() => randomizeCircles(10)">Rand</UButton>
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