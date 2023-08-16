<script setup lang="ts">
import { rotate } from '@/components/Experiment/rotate';
import { getNormal } from '@/components/Experiment/normal';
import { ring, sphere, torus, combine, subtract } from '@/components/Experiment/shapes';

function SDFScene() {
  return subtract(
    sphere(rotate, 1.5),
    torus(rotate, [0.7, 1.0])
  );

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