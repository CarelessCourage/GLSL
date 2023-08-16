<script setup lang="ts">
import { SRGBColorSpace, NoToneMapping, BasicShadowMap } from 'three'

const gl = {
  clearColor: '#000000',
  shadows: true,
  alpha: false,
  shadowMapType: BasicShadowMap,
  outputColorSpace: SRGBColorSpace,
  toneMapping: NoToneMapping,
  windowSize: true,
}

onUnmounted(() => {
})

</script>

<template>
  <div class="tres">
    <TresCanvas v-bind="gl">
      <OrbitControls />
      <TresAmbientLight :intensity="10" />
      <TresPerspectiveCamera 
        :position="[0, 0, 6]"
      />
      <FBO />
      <TresGridHelper v-if="false" :args="[160, 160]" />
    </TresCanvas>
  </div>
</template>

<style>
.tres {}
</style>