// App.vue
<script setup lang="ts">
import CustomShaderMaterial from 'three-custom-shader-material/vanilla'
import { Vector2, Vector4 } from 'three'
import { TresCanvas, useRenderLoop } from '@tresjs/core'
import { MeshPhysicalMaterial } from 'three'

import vertex from './shaders/vertex.glsl'
import fragment from './shaders/fragment.glsl'

import wobbleVertex from './shaders/wobble/vertex.glsl'
import wobbleFragment from './shaders/wobble/fragment.glsl'

import spiralVertex from './shaders/spiral/vertex.glsl'
import spiralFragment from './shaders/spiral/fragment.glsl'

import foldVertex from './shaders/fold/vertex.glsl'
import foldFragment from './shaders/fold/fragment.glsl'

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

// const waterMaterial = new CustomShaderMaterial({
//   baseMaterial: MeshPhysicalMaterial,
//   transmission: 1,
//   thickness: 0.5,
//   roughness: 0,
//   envMapIntensity: 1.5,
//   vertexShader: vertexShader,
//   uniforms: {
//     uTime: { value: 0 },
//   }
// })

const { onLoop, resume } = useRenderLoop()
resume()
onLoop(({ elapsed }) => {
  if (meshRef.value) {
    meshRef.value.material.uniforms.uTime.value = elapsed
    meshRef.value.material.uniforms.resolution.value.x = window.innerWidth
    meshRef.value.material.uniforms.resolution.value.y = window.innerHeight
    //console.log(meshRef.value)
  }
})
</script>

<template>
  <div class="tres">
    <TresCanvas clear-color="#111" shadows alpha :windowSize="true">
      <TresPerspectiveCamera :position="[0, 1, 11]" />

      <!-- <TresMesh v-if="true" ref="meshRef" :position="[0, 1, 0]">
        <TresSphereGeometry :args="[2, subdivisions, subdivisions]" />    
        <TresShaderMaterial
          ref="materialRef"
          :vertex-shader="wobbleVertex"
          :fragment-shader="wobbleFragment"
          :uniforms="uniforms"
        />
      </TresMesh> -->

      <!-- <TresMesh v-if="false" ref="meshRef" :position="[0, 1, 0]">
        <TresSphereGeometry :args="[2, subdivisions, subdivisions]" />    
        <TresShaderMaterial
          ref="materialRef"
          :vertex-shader="spiralVertex"
          :fragment-shader="spiralFragment"
          :uniforms="uniforms"
        />
      </TresMesh> -->

      <!-- <TresMesh v-if="false" :position="[0, 1, 0]">
        <TresPlaneGeometry :material="waterMaterial" :args="[width, height, subdivisions, subdivisions]" />    
      </TresMesh> -->

      <!-- <TresMesh v-if="true" ref="meshRef" :position="[0, 1, 0]">
        <TresIcosahedronGeometry :args="[2, subdivisions]" />
        <TresShaderMaterial
          ref="materialRef"
          :vertex-shader="foldVertex"
          :fragment-shader="foldFragment"
          :uniforms="uniforms"
        />
      </TresMesh> -->

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
.tres {
  margin: auto;
  background: rgba(255, 0, 0, 0.289);
  /* height: 32rem;
  width: 32rem; */
}
</style>