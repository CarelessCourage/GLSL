precision mediump float;
uniform vec4 resolution;
uniform float uTime;

varying vec2 vUv;
varying vec3 vNormal;

mat4 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

vec3 rotate(vec3 v, vec3 axis, float angle) {
	mat4 m = rotationMatrix(axis, angle);
	return (m * vec4(v, 1.0)).xyz;
}

float sdBox(vec3 p, vec3 b) {
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sphere(vec3 p, float r) {
    return length(p) - r;
}

float SineCrazy(vec3 p) {
    return 1.0 - (sin(p.x) + sin(p.y) + sin(p.z))/3.0;
}

float SineCrazyWrapper(vec3 p) {
    float minScale = 10.0;
    float scaleFactor = minScale;
    float scale = minScale + scaleFactor*sin(uTime*0.5);
    float amount = 0.85;
    return (amount - SineCrazy(p*scale))/scale;
}

float scene(vec3 p) {
    vec3 p1 = rotate(p, vec3(1.0, 1.0, 1.0), uTime)/2.0;
    float box = sdBox(p1, vec3(0.4));//not used atm
    float sphere = sphere(p, 0.5);
    float sine = SineCrazyWrapper(p1);

    return max(sphere, sine);
}

vec3 getNormal(vec3 p) {
    vec2 o = vec2(0.001, 0.0);
    return normalize(vec3(
        scene(p + o.xyy) - scene(p - o.xyy),
        scene(p + o.yxy) - scene(p - o.yxy),
        scene(p + o.yyx) - scene(p - o.yyx)
    ));
}

vec3 GetColor(float amount) {
    vec3 col = 0.5 + 0.5*cos(6.28318*(vec3(0.2, 0.0, 0.0) + amount + vec3(1.0, 1.0, 0.5)));
    return col * amount;
}

vec3 GetColorAmount(vec3 p) {
    float amount = clamp((1.5 - length(p))/2.0, 0.0, 1.0);
    vec3 col = 0.5 + 0.5*cos(6.28318*(vec3(0.2, 0.0, 0.0) + amount + vec3(1.0, 1.0, 0.5)));
    return col * amount;
}

void main() {
    float move = sin(uTime) * 0.5 + 0.5;//not used atm
    vec3 newUV = vec3(vUv - vec2(0.5), -1.0);
    vec3 p = newUV;

    float bw = step(newUV.x, 0.5);
    vec3 camPos = vec3(0.0, 0.0, 2.0);
    vec3 ray = normalize(p);
    vec3 rayPos = camPos;

    float curDist = 0.0;
    float rayLen = 0.0;

    float definiton = 0.6;
    float brightness = 0.02;
    vec3 light = vec3(1.0, 1.0, 0.5);
    vec3 color = vec3(0.0);

    for(int i = 0; i<= 100; i++){
        curDist = scene(rayPos);
        rayLen += definiton*curDist;

        rayPos = camPos + ray * rayLen;

        if(abs(curDist) < 0.001){
            vec3 n = getNormal(rayPos);

            float diff = dot(n, light) + 1.0;

            float colorPosition = length(rayPos) * sin(uTime) * 0.5 + 1.0;

            if(length(rayPos) > 0.499){
                colorPosition = length(rayPos);
            }

            //color = GetColor(colorPosition) * diff;
            break;
        }

        // if(rayLen > 10.0){
        //     vec3 n = getNormal(rayPos);
        //     float diff = dot(n, light) + 1.0;
        //     //color = vec3(0.0);
        //     break;
        // }

        color += brightness * GetColorAmount(rayPos);
    }

    gl_FragColor = vec4(color, 1.0 );
}

