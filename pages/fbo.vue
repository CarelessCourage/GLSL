<script setup lang="ts">
import { OrbitControls } from '@tresjs/cientos'
import { TresCanvas } from '@tresjs/core'
import { SRGBColorSpace, NoToneMapping, BasicShadowMap } from 'three'

const gl = {
  clearColor: '#000000',
  shadows: true,
  alpha: false,
  shadowMapType: BasicShadowMap,
  outputColorSpace: SRGBColorSpace,
  toneMapping: NoToneMapping,
}

</script>
<template>
  <TresCanvas v-bind="gl" ref="canvas">
    <OrbitControls />
    <TresAmbientLight :intensity="10" />
    <TresPerspectiveCamera 
      :position="[0, 4.1, 9.5]" 
      :rotation="[0, 0, 0]"
    />
    <FBO />
    <TresGridHelper v-if="false" :args="[160, 160]" />
  </TresCanvas>
</template>
