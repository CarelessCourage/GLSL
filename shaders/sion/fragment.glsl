precision mediump float;
uniform vec4 resolution;
uniform float uTime;
uniform float uBlur;
uniform float uAlphaBlur;
uniform float uSeed;
uniform vec3 uCircles[10];
uniform float uSize;
uniform float uStrength;
uniform vec3 uvOrigin;
uniform vec2 uOffset;

varying vec2 vUv;
varying vec3 vNormal;

//generic rotation formula
vec2 rot(vec2 uv,float a){
	return vec2(uv.x*cos(a)-uv.y*sin(a),uv.y*cos(a)+uv.x*sin(a));
}

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
    float blur = uBlur;
    float c = drawCircle2(uv, circle, blur);
    if (c > 0.) {
        return vec3(vUv.x * c, vUv.y * c, 1.0 * c);
    }
}

float remap(float value, float oldMin, float oldMax, float newMin, float newMax) {
    return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin;
}

vec2 offsetUV(vec2 uv, vec2 point) {
    float remapX = map(point.x, 0.0, 1.0, -1.0, 1.0);
    float remapY = map(point.y, 0.0, 1.0, -1.0, 1.0);
    vec2 offset = vec2(remapX, remapY);

    float scale = uvOrigin.z;
    vec2 objectiveCenter = vec2(0.5, 0.5);
    vec2 origin = uvOrigin.xy;
    float scaleCenter = scale / 2.0;
    float left = origin.x - scaleCenter;
    float right = origin.x + scaleCenter;
    float top = origin.y - scaleCenter;
    float bottom = origin.y + scaleCenter;

    float xmap = map(uv.x, left, right, 0.0, 1.0);
    float ymap = map(uv.y, top, bottom, 0.0, 1.0);

    vec2 xUv = vec2(xmap, ymap) + offset;

    //global rotation and zoom
	//xUv=rot(uv,uTime);
	//xUv*=1.0+1.0;

    return xUv;
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

vec2 combineUV(float alpha, vec2 circleUVs) {
    if(alpha > 0.0) {
        return circleUVs;
    } else {
        return vUv;
    }
}

float circleAlpha = 0.0;
float outerCircleAlpha = 0.0;
float outerBlur = 0.0;
float innerBlur = 0.0;
vec2 circleUVs = vec2(0.0);
vec3 colorDots = vec3(0.0);

vec2 displaceUV(vec2 uv) {
    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        float d = drawCircle2(uv, circle, uAlphaBlur);
        float d2 = drawCircle2(uv, circle, uAlphaBlur);
        circleAlpha = max(circleAlpha, d);
        outerCircleAlpha = max(outerCircleAlpha, d2);
    }

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        vec2 luv = localUV(uv, circle);
        float remapOffset = -0.25;
        vec2 newMap = vec2(0.0 - remapOffset, 1.0 + remapOffset);
        float remappeX = remap(circle.x, 0.0, 1.0, newMap.x, newMap.y);
        float remappeY = remap(circle.y, 0.0, 1.0, newMap.x, newMap.y);
        vec2 pointUv = offsetUV(luv, vec2(remappeX, remappeY));

        if(luv != vec2(0.0)) {
            circleUVs = pointUv;
        }
    }

    vec2 dUv = combineUV(circleAlpha, circleUVs);

    vec2 test = mix(vec2(circleAlpha), circleUVs, circleAlpha);
    vec2 mUv = mix(vUv, test, circleAlpha);
    vec2 mUv2 = mix(mUv, vUv, uStrength);
    return mUv2;
}

void main() {
    vec2 uv = vUv; //* 2.0 - 1.0;
    //vec2 yUv = offsetUV(uv, uOffset);
    //vec2 xUv = displaceUV(yUv);
    vec2 yUv = displaceUV(uv);
    vec2 xUv = yUv;

    vec3 displacement = vec3(xUv.y, xUv.x, 0.0);

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        float d = drawCircle(xUv, circle, uBlur);
        outerBlur = max(outerBlur, d);
    }

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        float d = drawCircle2(xUv, circle, uBlur);
        innerBlur = max(innerBlur, d);
    }

    for (int i = 0; i < 10; i++) {
        vec3 circle = uCircles[i];
        if(circle.z == 0.0) continue;
        vec3 d = ColorSprite(xUv, circle);
        colorDots = max(colorDots, d);
    }

    //Blurs
    float outerBlur = outerBlur * uBlur;
    float circleBlur = outerBlur + innerBlur;
    vec3 blur = vec3(circleBlur);

    //uv
    vec3 uvTest = vec3(yUv.x, yUv.y, 0.0);

    gl_FragColor = vec4(blur, 1.0);
}

