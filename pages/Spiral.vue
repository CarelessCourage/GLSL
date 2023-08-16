<script setup lang="ts">
import foldVertex from '../shaders/spiral/vertex.glsl'
import foldFragment from '../shaders/spiral/fragment.glsl'

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
      <OrbitControls />
      <TresMesh v-if="true" ref="meshRef" :position="[0, 1, 0]">
        <TresSphereGeometry :args="[2, subdivisions, subdivisions]" />   
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
.tres {}
</style>