precision mediump float;
uniform vec4 resolution;
uniform float uTime;
uniform float uBlur;
uniform float uSeed;
uniform vec3 uCircles[10];

varying vec2 vUv;
varying vec3 vNormal;

float map(float value, float min1, float max1, float min2, float max2) {
    // Convert the current value to a percentage
    // 0% - min1, 100% - max1
    //float perc = (value - min1) / (max1 - min1);

    // Do the same operation backwards with min2 and max2
    //float value = perc * (max2 - min2) + min2;
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

// float clamp(float value, float min, float max) {
//     return min(max(value, min), max);
// }

float drawCircle(vec2 uv, vec3 circle, float blur){
    float d = length(uv - circle.xy);
    float radius = circle.z + blur;
    return smoothstep(radius, radius - blur, d);
}

float drawCircle2(vec2 uv, vec3 circle, float blur){
    float d = length(uv - circle.xy);
    float radius = circle.z;
    return smoothstep(radius, radius - blur * 3.5, d);
}

vec3 ColorSprite(vec2 uv, vec3 circle) {
    float blur = 0.122;
    float c = drawCircle2(uv, circle, blur);
    if (c > 0.) {
        return vec3(vUv.x * c, vUv.y * c, 1.0 * c);
    }
}

float remap(float value, float oldMin, float oldMax, float newMin, float newMax) {
    return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin;
}

vec3 DisplaceSprite(vec2 uv, vec3 circle) {
    float radius = circle.z;


    float from = circle.x - radius * 1.5;
    float to = circle.x + radius * 2.5;

    float UvX = remap(uv.x + radius * 1.5, from, to, -1.0, 1.0);
    float UvY = remap(uv.y + radius * 1.5, from, to, -1.0, 1.0);

    vec2 localUV = vec2(UvX, UvY);
    
    float blur = uBlur; // 0.122;
    float c = drawCircle2(uv, circle, blur);
    if (c > 0.) {
        return vec3(localUV.x * c, localUV.y * c, localUV.y * c);
    }
}

float outerBlur = 0.0;
float innerBlur = 0.0;
vec3 xDisplace = vec3(0.0);
vec3 yDisplace = vec3(0.0);
vec3 colorDots = vec3(0.0);

void main() {
    vec2 uv = vUv * 2.0 - 1.0;

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        float d = drawCircle(uv, circle, uBlur);
        outerBlur = max(outerBlur, d);
    }

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        float d = drawCircle2(uv, circle, uBlur);
        innerBlur = max(innerBlur, d);
    }

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        vec3 d = ColorSprite(uv, circle);
        colorDots = max(colorDots, d);
    }

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        vec3 d = DisplaceSprite(uv, circle);
        xDisplace = max(xDisplace, d);
    }

    vec3 gradient = vec3(1.0, 1.0, 1.0);
    vec3 colors = gradient * outerBlur * uBlur;
    vec3 colors2 = gradient * innerBlur;
    vec3 colors3 = vec3(0.0) + colorDots;
    vec3 colors4 = vec3(0.0) + xDisplace;
    
    //gl_FragColor = vec4(colors + colors2, 1.0);
    //gl_FragColor = vec4(vUv.x, vUv.y, 1.0, 1.0);
    vec3 lol = DisplaceSprite(uv, uCircles[0]);
    vec3 dotlol = ColorSprite(uv, vec3(uCircles[0].x, 0.0, 0.4));

    float blur = uBlur; // 0.122;
    float ddd = drawCircle2(uv, vec3(uCircles[0].x, 0.0, uCircles[0].z), blur);
    vec3 dotlol2 = vec3(0.0, 0.0, ddd);

    gl_FragColor = vec4(max(lol, dotlol2), 1.0);
}

