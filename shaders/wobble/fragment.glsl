// fragment.glsl
precision mediump float;
uniform vec4 resolution;
varying vec2 vUv;
varying vec3 vPos;

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float scene(vec3 p) {
    return sdBox(p, vec3(0.5));
}

vec3 getNormal(vec3 p) {
    vec2 e = vec2(0.001, 0.0);
    return normalize(vec3(
        scene(p + e.xyy) - scene(p - e.xyy),
        scene(p + e.yxy) - scene(p - e.yxy),
        scene(p + e.yyx) - scene(p - e.yyx)
    ));
}

vec3 light = vec3(-1.0, 1.0, 1.0);
vec3 color = vec3(1.0, 0.2, 0.4);

void main() {
    vec2 newUV = (vUv - vec2(0.5))*vec2(0.5);

    float bw = step(newUV.y, 0.6);
    vec3 camPos = vec3(0.0, 0.0, 2.0);

    vec3 ray = normalize(vec3(newUV, -1.0));
    vec3 rayPos = camPos;

    float curDist = 0.0;
    float rayLen = 0.0;

    for (int i = 0; i < 60; i++) {
        curDist = scene(rayPos);
        rayLen += curDist;
        rayPos = camPos + ray * rayLen;

        if(abs(curDist) < 0.001) {
            vec3 normal = getNormal(rayPos);
            float diff = dot(normal, light);
            //color = vec3(diff);
        }
    }

    //gl_FragColor = vec4(color, 1.0);
    gl_FragColor = vec4(1.0, vUv.y, 0.5, 1.0);
}