<script setup lang="ts">
import * as THREE from 'three'
import { reactive, ref } from 'vue'
import { useRenderLoop, useTresContext } from '@tresjs/core'
import { useTweakPane } from '@tresjs/cientos'

import vertex from '../shaders/refraction/vertex.glsl'
import fragment from '../shaders/refraction/fragment.glsl'

const { pane } = useTweakPane()

const balls = reactive({x: 5, y: 5 })

const f2 = pane.addFolder({
  title: 'Clunky',
  expanded: false
});

f2.addInput(balls, 'x', {
  step: 1,
  min: 0,
  max: 10,
})

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

let controls = {
  light: new THREE.Vector3(-1.0, 1.0, 1.0),
  diffuseness: 0.2,
  shininess: 40.0,
  fresnel: 6.0,
  ior: { r: 1.15, y: 1.16, g: 1.18, c: 1.22, b: 1.22, p: 1.22 },
  saturation: 1.08,
  chromaticAberration: 0.6,
  refraction: 0.4,
}

f2.addInput(controls, 'diffuseness', {
  step: 0.05,
  min: 0.2,
  max: 5,
})

const light = pane.addFolder({
  title: 'Light',
  expanded: true,   // optional
});

light.addInput(controls, 'shininess', {
  step: 0.05,
  min: 0.6,
  max: 70,
})

light.addInput(controls, 'fresnel', {
  step: 0.05,
  min: 0.6,
  max: 6,
})

const ior = pane.addFolder({
  title: 'ior',
  expanded: true,
});

ior.addInput(controls.ior, 'r', {
  step: 0.05,
  min: 1.0,
  max: 2.33,
})

ior.addInput(controls.ior, 'y', {
  step: 0.05,
  min: 1.0,
  max: 2.33,
})

ior.addInput(controls.ior, 'g', {
  step: 0.05,
  min: 1.0,
  max: 2.33,
})

ior.addInput(controls.ior, 'c', {
  step: 0.05,
  min: 1.0,
  max: 2.33,
})

ior.addInput(controls.ior, 'b', {
  step: 0.05,
  min: 1.0,
  max: 2.33,
})

ior.addInput(controls.ior, 'p', {
  step: 0.05,
  min: 1.0,
  max: 2.33,
})

const other = pane.addFolder({
  title: 'other',
  expanded: true,
});

other.addInput(controls, 'saturation', {
  step: 0.05,
  min: 1.0,
  max: 1.25,
})

other.addInput(controls, 'chromaticAberration', {
  step: 0.05,
  min: 0.0,
  max: 1.50,
})

other.addInput(controls, 'refraction', {
  step: 0.05,
  min: 0.0,
  max: 1.0,
})

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
    <TresTorusGeometry :args="[1.5, 0.6, 70, 70]" />
    <TresShaderMaterial
      :vertex-shader="vertex"
      :fragment-shader="fragment"
      :uniforms="uniforms"
    />
  </TresMesh>
</template>
