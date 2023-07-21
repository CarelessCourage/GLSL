// fragment.glsl
precision mediump float;
uniform vec4 resolution;
uniform float uTime;

varying vec2 vUv;
varying vec3 vNormal;
varying float vDisplacement;

void main() {
    gl_FragColor = vec4(vec3(vDisplacement), 1.0);
}

