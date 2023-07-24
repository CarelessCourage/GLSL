<script setup lang="ts">
import vertex from '../shaders/impact/vertex.glsl'
import fragment from '../shaders/impact/fragment.glsl'

const width = ref(10)
const height = ref(10)
const subdivisions = ref(260)

const meshRef = ref<any>(null)
const materialRef = ref<any>(null)
const uniforms = {
  uTime: { value: 0 },
}

const { onLoop, resume } = useRenderLoop()
resume()
onLoop(({ elapsed }) => {
  if (!meshRef.value) return
  meshRef.value.material.uniforms.uTime.value = elapsed
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