<script setup lang="ts">
import { registerCamera } from './camera';
import { registerGetNormal, getNormal } from './normal';
import { registerRotate, rotate } from './rotate';

import { 
  registerScene,
  registerRaymarch, 
  registerMarchHit, 
  marchHit
} from './raymarch';

import {  
  ring,
  sphere, 
  combine,
  registerTorus 
} from './shapes';

const props = defineProps({
  width: { type: Number, default: 10 },
  height: { type: Number, default: 10 },
  subdivisions: { type: Number, default: 260 },
  scene: { type: String, default: '0.0' },
  material: { type: String, default: '0.0' },
})

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


const vertex = `
  uniform vec2 uAmplitude;
  uniform vec2 uFrequency;
  uniform float uTime;

  varying vec2 vUv;
  varying vec3 vNormal;
  varying float vDisplacement;

  #define PI 3.1415926535897932384626433832795

  void main() {
      vec4 modelPosition = modelMatrix * vec4(position, 1.0);
      vec4 viewPosition = viewMatrix * modelPosition;
      gl_Position = projectionMatrix * viewPosition;

      vUv = uv;
      vNormal = normal;
  }
`;

const fragment = `
  precision mediump float;
  uniform float uTime;

  varying vec2 vUv;
  varying vec3 vNormal;

  ${registerTorus}
  ${registerRotate}

  ${registerScene(props.scene)}

  ${registerGetNormal}
  ${registerRaymarch}
  ${registerCamera}

  ${registerMarchHit(props.material)}

  void main() {
    vec2 screenPos = vUv * 2.0 - 1.;
    vec3 color = ${marchHit('screenPos')};
    gl_FragColor = vec4(color, 1);
  }
`
</script>

<template>
  <TresMesh v-if="true" ref="meshRef" :position="[0, 0, 0]">
    <TresPlaneGeometry :args="[width, height, subdivisions, subdivisions]" />    
    <TresShaderMaterial
      ref="materialRef"
      :vertex-shader="vertex"
      :fragment-shader="fragment"
      :uniforms="uniforms"
    />
  </TresMesh>
</template>

<style>
.tres {}
</style>