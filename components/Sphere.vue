<script setup lang="ts">
import { ref } from 'vue'
import { Vector2, Vector3 } from 'three'
import { useRenderLoop } from '@tresjs/core'
import { OrbitControls } from '@tresjs/cientos'

import vertexShader from '../shaders/vertex.glsl'
import fragmentShader from '../shaders/fragment.glsl'

const blobRef = ref(null)
const materialRef = ref(null)
const lol = ref('lol')

const uniforms = {
  uTime: { value: 0 },
  uAmplitude: { value: new Vector2(0.1, 0.1) },
  uFrequency: { value: new Vector2(20, 5) },
  resolution: { value: new Vector2(600, 600) },
}

const { onLoop, resume } = useRenderLoop()
resume()
onLoop(({ elapsed }) => {
  if (blobRef.value) {
    blobRef.value.material.uniforms.uTime.value = elapsed
  }
})
</script>

<template>
  <TresCanvas shadows alpha>
    <TresPerspectiveCamera :position="[0, 0, 1]" />
    <OrbitControls />
    <TresMesh ref="blobRef" :position="[0, 0, 0]">
      <!-- <TresSphereGeometry :args="[2, 32, 32]" /> -->
      <TresPlaneGeometry :args="[, 10, 10, 10]" />
      <!-- <TresMeshBasicMaterial :color-r="0.7" :color-b="0.3" /> -->
      <!-- <TresShaderMaterial
        ref="materialRef"
        :vertex-shader="vertexShader"
        :fragment-shader="fragmentShader"
        :uniforms="uniforms"
      /> -->
    </TresMesh>
    <TresAmbientLight :intensity="0.5" />
  </TresCanvas>
</template>