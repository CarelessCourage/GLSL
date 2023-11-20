precision mediump float;
uniform vec4 resolution;
uniform float uTime;
uniform float uBlur;
uniform float uSeed;
uniform vec3 uCircles[10];

varying vec2 vUv;
varying vec3 vNormal;

// for (int i = 0; i < 10; i++) {
//     float t = float(i) / 10.0;
//     float x = sin(uTime + t * 3.1415 * 2.0) * 0.5;
//     float y = cos(uTime + t * 3.1415 * 2.0) * 0.5;
//     float d = drawCircle(uv, vec2(x, y), 0.1);
//     d3 = max(d3, d);
// }

//function to draw a circle at a spot
float drawCircle(vec2 uv, vec3 circle){
    float d = length(uv - circle.xy);
    float r = circle.z + uBlur;
    float c = smoothstep(r, r - uBlur, d);
    //float color = c * d;
    //float dist = distance(uv, pos);
    //vec2 circleUV = vec2(dist / radius);
    return c;
}

float noise(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float randRange2(vec2 co) {
    float random = noise(co + vec2(uSeed));
    return -1.0 + random * (1.0 - -1.0);
}

float randRange(vec2 co) {
    float a = 12.9898;
    float b = 78.233;
    float c = 43758.5453;
    float dt= dot(co.xy ,vec2(a,b));
    float sn= mod(dt,3.14);
    return fract(sin(sn + uSeed) * c);
}

// float drawRandomCircles(vec2 uv) {
//     float maxD = 0.0;
//     for (int i = 0; i < int(1); i++) {
//         float x = randRange(vec2(uv.x, float(i)));
//         float y = randRange(vec2(uv.y, float(i)));
//         float radius = clamp(randRange(vec2(x, y)) * 0.5, 1.0, 6.0);
//         float d = drawCircle(uv, vec2(x, y), radius);
//         maxD = max(maxD, d);
//     }
//     return maxD;
// }


float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float randomLowChance (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float d4 = 0.0;

void main() {
    vec2 uv = vUv * 2.0 - 1.0;
    float x = vUv.x;
    float y = vUv.y;
    float xy = x * y;

    float d = drawCircle(uv, vec3(0.0, 0.0, 0.3));
    float d2 = drawCircle(uv, vec3(-0.5, 0.7, 0.25));
    float d3 = max(d, d2);

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        float d = drawCircle(uv, circle);
        d4 = max(d4, d);
    }

    vec3 colors = vec3(1.0) * d4;
    gl_FragColor = vec4(colors, 1.0);
}

