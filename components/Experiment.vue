<script setup lang="ts">
import { rotate } from './Experiment/rotate';
import { getNormal } from './Experiment/normal';
import { ring, sphere, combine } from './Experiment/shapes';

function SDFScene() {
  return combine(sphere(rotate, 0.5), ring(rotate));
}

function SDFMaterial() {
  return getNormal(`rayOrigin + rayDirection * collision`);
}
</script>

<template>
  <div class="tres">
    <TresCanvas clear-color="#111" shadows alpha :windowSize="true">
      <TresPerspectiveCamera :position="[0, 0, 11]" />
      <ExperimentMesh
        :scene="SDFScene()"
        :material="SDFMaterial()"
      />
    </TresCanvas>
  </div>
</template>

<style>
.tres {}
</style>