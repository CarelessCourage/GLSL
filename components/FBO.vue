<script setup lang="ts">
import * as THREE from 'three'
import { reactive, ref } from 'vue'
import { useRenderLoop, useTresContext } from '@tresjs/core'
import { controls } from '../composables/useWindowPane'

import vertex from '../shaders/refraction/vertex.glsl'
import fragment from '../shaders/refraction/fragment.glsl'

const balls = reactive({x: 5, y: 5 })

function getColumn(index: number) {
  return -(balls.x + 1) + index * 2
}

function getRow(index: number) {
  return -4.5 - (balls.y / 2) + index * 2
}

const meshRef = ref<any>(null)

const uniforms = {
  uTexture: {
    value: null
  },
  uIorR: { value: 1.0 },
  uIorY: { value: 1.0 },
  uIorG: { value: 1.0 },
  uIorC: { value: 1.0 },
  uIorB: { value: 1.0 },
  uIorP: { value: 1.0 },
  uRefractPower: {
    value: 0.2
  },
  uChromaticAberration: {
    value: 1.0
  },
  uSaturation: { value: 0.0 },
  uShininess: { value: 40.0 },
  uDiffuseness: { value: 0.2 },
  uFresnelPower: { value: 8.0 },
  uLight: {
    value: new THREE.Vector3(-1.0, 1.0, 1.0)
  },
  winResolution: {
    value: new THREE.Vector2(
      window.innerWidth,
      window.innerHeight
    ).multiplyScalar(Math.min(window.devicePixelRatio, 2)) // if DPR is 3 the shader glitches 🤷‍♂️
  }
}

const state = useTresContext()
const rt = useFBO()

const { onLoop, resume } = useRenderLoop()
resume()
onLoop(() => {
  const { scene, camera, renderer } = state;
  if(!meshRef.value) return
  if(!camera.value) return
  if(!rt.value) return
  
  renderer.value.setRenderTarget(rt.value)
  renderer.value.render(scene.value, camera.value)
  meshRef.value.material.uniforms.uTexture.value = rt.value.texture;
  renderer.value.setRenderTarget(null)
  
  meshRef.value.material.uniforms.uDiffuseness.value = controls.diffuseness;
  meshRef.value.material.uniforms.uShininess.value = controls.shininess;
  meshRef.value.material.uniforms.uLight.value = controls.light;
  meshRef.value.material.uniforms.uFresnelPower.value = controls.fresnel;

  meshRef.value.material.uniforms.uIorR.value = controls.ior.r;
  meshRef.value.material.uniforms.uIorY.value = controls.ior.y;
  meshRef.value.material.uniforms.uIorG.value = controls.ior.g;
  meshRef.value.material.uniforms.uIorC.value = controls.ior.c;
  meshRef.value.material.uniforms.uIorB.value = controls.ior.b;
  meshRef.value.material.uniforms.uIorP.value = controls.ior.p;

  meshRef.value.material.uniforms.uSaturation.value = controls.saturation;
  meshRef.value.material.uniforms.uChromaticAberration.value = controls.chromaticAberration;
  meshRef.value.material.uniforms.uRefractPower.value = controls.refraction;
})

</script>
<template>
  <TresGroup v-for="row in balls.y" :key="row + 'box'">
    <TresGroup 
      v-for="col in balls.x" :key="col + 'box'" 
      :position="[0, getRow(row), 0]"
    >
      <TresMesh :position="[getColumn(col), 1, -4]">
        <TresSphereGeometry :args="[0.5, 10, 10]" />
        <TresMeshStandardMaterial :color="0xffffff" />
      </TresMesh>
    </TresGroup>
  </TresGroup>
  
  <TresMesh ref="meshRef" :position="[0, 0, 0]">
    <TresTorusGeometry :args="[1.5, 0.6, 320, 320]" />
    <TresShaderMaterial
      :vertex-shader="vertex"
      :fragment-shader="fragment"
      :uniforms="uniforms"
    />
  </TresMesh>
</template>
