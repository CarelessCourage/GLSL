<script setup lang="ts">
import { Vector2, Vector4 } from 'three'
import vertex from '../shaders/sdf/vertex.glsl'
import fragment from '../shaders/sdf/fragment.glsl'

const width = ref(10)
const height = ref(10)
const subdivisions = ref(260)

const meshRef = ref<any>(null)
const materialRef = ref<any>(null)
const uniforms = {
  uTime: { value: 0 },
  uAmplitude: { value: new Vector2(0.1, 0.1) },
  uFrequency: { value: new Vector2(20, 5) },
  resolution: { value: new Vector4(0, 0, 0, 0) },
}

const { onLoop, resume } = useRenderLoop()
resume()
onLoop(({ elapsed }) => {
  if (meshRef.value) {
    meshRef.value.material.uniforms.uTime.value = elapsed
    meshRef.value.material.uniforms.resolution.value.x = window.innerWidth
    meshRef.value.material.uniforms.resolution.value.y = window.innerHeight
  }
})
</script>

<template>
  <div class="tres">
    <TresCanvas clear-color="#111" shadows alpha :windowSize="true">
      <TresPerspectiveCamera :position="[0, 1, 11]" />
      <TresMesh v-if="true" ref="meshRef" :position="[0, 0, 0]">
        <TresPlaneGeometry :args="[width, height, subdivisions, subdivisions]" />    
        <TresShaderMaterial
          ref="materialRef"
          :vertex-shader="vertex"
          :fragment-shader="fragment"
          :uniforms="uniforms"
        />
      </TresMesh>
    </TresCanvas>
  </div>
</template>

<style>
.tres {}
</style>