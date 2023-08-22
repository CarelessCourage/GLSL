precision mediump float;
uniform vec4 resolution;
uniform float uTime;

varying vec2 vUv;
varying vec3 vNormal;

void main() {
    vec2 uv = vUv * 2.0 - 1.0;

    float d = length((uv + vec2(0.2, -0.4)) * 0.2);
    float r = 0.5 + 0.5  * sin(uTime + d * 10.0);
    float g = 0.5 + 0.5 * cos(uTime + d * 10.0 + 2.0);
    float b = 0.5 + 0.5 * cos(uTime + d * 10.0 + 4.0);
    gl_FragColor = vec4(r, g, b, 1.0);
}

