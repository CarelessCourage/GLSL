precision mediump float;
uniform vec4 resolution;
uniform float uTime;
uniform float uBlur;
uniform float uSeed;
uniform vec3 uCircles[10];
uniform float uSize;

varying vec2 vUv;
varying vec3 vNormal;

float map(float value, float min1, float max1, float min2, float max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

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

vec2 localUV(vec2 uv, vec3 circle) {
    float radius = circle.z;

    float fromX = circle.x - radius * 1.5;
    float toX = circle.x + radius * 2.5;

    float fromY = circle.y - radius * 1.5;
    float toY = circle.y + radius * 2.5;

    float UvX = remap(uv.x + radius * 1.5, fromX, toX, -1.0, 1.0);
    float UvY = remap(uv.y + radius * 1.5, fromY, toY, -1.0, 1.0);

    vec2 localUV = vec2(UvX, UvY);
    
    float blur = 0.00122;
    float c = drawCircle2(uv, vec3(circle.xy, circle.z + uSize), blur);
    
    return vec2(localUV.x * c, localUV.y * c);
}

vec2 displaceUV(float alpha, vec2 circleUVs) {
    if(alpha > 0.0) {
        return circleUVs;
    } else {
        return vUv;
    }
}

float circleAlpha = 0.0;
float outerBlur = 0.0;
float innerBlur = 0.0;
vec2 circleUVs = vec2(0.0);
vec3 colorDots = vec3(0.0);

void main() {
    vec2 uv = vUv * 2.0 - 1.0;

     for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        float d = drawCircle2(uv, circle, 0.001);
        circleAlpha = max(circleAlpha, d);
    }

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
        vec3 circle2 = uCircles[i + 1];
        if(circle.z == 0.0) continue;
        vec2 luv = localUV(uv, circle);
        circleUVs = max(circleUVs, luv);

        if(luv != vec2(0.0)) {
            circleUVs = luv;
        }
    }

    //Blurs
    float outerBlur = outerBlur * uBlur;
    float circleBlur = outerBlur + innerBlur;

    vec2 dUv = displaceUV(circleAlpha, circleUVs);

    gl_FragColor = vec4(dUv, 1.0, 1.0);
}

