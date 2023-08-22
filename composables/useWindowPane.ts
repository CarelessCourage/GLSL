//import { Pane } from 'tweakpane'
import * as THREE from 'three'

export let controls = {
  light: new THREE.Vector3(-1.0, 1.0, 1.0),
  diffuseness: 0.2,
  shininess: 40.0,
  fresnel: 6.0,
  ior: { r: 1.15, y: 1.16, g: 1.18, c: 1.22, b: 1.22, p: 1.22 },
  saturation: 1.08,
  chromaticAberration: 0.6,
  refraction: 0.4,
}

// const f2 = pane.addFolder({
//   title: 'Clunky',
//   expanded: false
// });

// f2.addInput(balls, 'x', {
//   step: 1,
//   min: 0,
//   max: 10,
// })


// f2.addInput(controls, 'diffuseness', {
//   step: 0.05,
//   min: 0.2,
//   max: 5,
// })

// const light = pane.addFolder({
//   title: 'Light',
//   expanded: true,   // optional
// });

// light.addInput(controls, 'shininess', {
//   step: 0.05,
//   min: 0.6,
//   max: 70,
// })

// light.addInput(controls, 'fresnel', {
//   step: 0.05,
//   min: 0.6,
//   max: 6,
// })

// const ior = pane.addFolder({
//   title: 'ior',
//   expanded: true,
// });

// ior.addInput(controls.ior, 'r', {
//   step: 0.05,
//   min: 1.0,
//   max: 2.33,
// })

// ior.addInput(controls.ior, 'y', {
//   step: 0.05,
//   min: 1.0,
//   max: 2.33,
// })

// ior.addInput(controls.ior, 'g', {
//   step: 0.05,
//   min: 1.0,
//   max: 2.33,
// })

// ior.addInput(controls.ior, 'c', {
//   step: 0.05,
//   min: 1.0,
//   max: 2.33,
// })

// ior.addInput(controls.ior, 'b', {
//   step: 0.05,
//   min: 1.0,
//   max: 2.33,
// })

// ior.addInput(controls.ior, 'p', {
//   step: 0.05,
//   min: 1.0,
//   max: 2.33,
// })

// const other = pane.addFolder({
//   title: 'other',
//   expanded: true,
// });

// other.addInput(controls, 'saturation', {
//   step: 0.05,
//   min: 1.0,
//   max: 1.25,
// })

// other.addInput(controls, 'chromaticAberration', {
//   step: 0.05,
//   min: 0.0,
//   max: 1.50,
// })

// other.addInput(controls, 'refraction', {
//   step: 0.05,
//   min: 0.0,
//   max: 1.0,
// })