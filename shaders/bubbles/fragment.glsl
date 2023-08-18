precision mediump float;
uniform vec4 resolution;
uniform float uTime;

varying vec2 vUv;
varying vec3 vNormal;

void main() {
    
    gl_FragColor = vec4(vUv.x, vUv.y, 0.0, 1.0);
}

