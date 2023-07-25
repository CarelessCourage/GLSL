precision mediump float;
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

float sdSphere(vec3 point, float radius) {
  return length(point) - radius;
}

float sdTorus( vec3 p, vec2 t ) {
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

//examples of how to combine shapes
float combine( float d1, float d2 ) { return min(d1, d2); }
float subtract( float d1, float d2 ) { return max(d1, -d2); }
float intersect( float d1, float d2 ) { return max(d1, d2); }

float scene(vec3 p) {
    //add all shapes togheter here
    vec3 p1 = rotate(p, vec3(1.0, 1.0, 1.0), uTime)/2.0;
    float torus = sdTorus(p1, vec2(1.0, 0.25));
    float sphere = sdSphere(p1, 1.15);
    float sphere2 = sdSphere(p1, 0.5);
    float ring = subtract(torus, sphere);
    return combine(ring, sphere2);
}

vec3 getNormal(vec3 p) {
    vec2 o = vec2(0.001, 0.0);
    return normalize(vec3(
        scene(p + o.xyy) - scene(p - o.xyy),
        scene(p + o.yxy) - scene(p - o.yxy),
        scene(p + o.yyx) - scene(p - o.yyx)
    ));
}

const int steps = 90;
const float maxdist = 20.0;
const float precis = 0.001;

float raymarch(vec3 rayOrigin, vec3 rayDir) {
  float latest = precis * 2.0;
  float dist = 0.0;
  float res = -1.0;

  // March along the ray
  for (int i = 0; i < steps; i++) {
    // Break if we're close enough or too far away
    if (latest < precis || dist > maxdist) break;
    vec3 p = rayOrigin + rayDir * dist;
    // Get the SDF distance
    float latest = scene(p);
    // Increment by the latest SDF distance
    dist += latest;
  }
  // if we're still within bounds,
  // set the result to the distance
  if (dist < maxdist) {
    res = dist;
  }

  return res;
}

vec3 camera(vec3 rayOrigin, vec3 rayTarget, vec2 screenPos, float lensLength) {
  // Get the camera's forward, right, and up vectors
  vec3 camForward = normalize(rayTarget - rayOrigin);
  vec3 camRight = normalize(cross(camForward, vec3(0, 1, 0)));
  vec3 camUp = normalize(cross(camRight, camForward));

  // Get the point on the camera plane in world space
  vec3 point = rayOrigin + camForward * lensLength + camRight * screenPos.x + camUp * screenPos.y;

  // Get the ray direction and normalize it
  vec3 rayDirection = normalize(point - rayOrigin);

  return rayDirection;
}

//Some good references for this code:
//A general overview of SDF: https://varun.ca/ray-march-sdf/
//An indepth look at SDF: https://jamie-wong.com/2016/07/15/ray-marching-signed-distance-functions/#surface-normals-and-lighting
//lots of example code for various SDF shapes and how to combine them: https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

void main() {
  vec3 color = vec3(0.0);
  float lensLength = 0.5;

  // Bootstrap a raymarching scene
  vec3 rayOrigin = vec3(3.5, 0., 3.5);
  vec3 rayTarget = vec3(0, 0, 0);
  // map from 0 to 1 to -1. to 1.
  vec2 screenPos = vUv * 2.0 - 1.;
  vec3 rayDirection = camera(rayOrigin, rayTarget, screenPos, lensLength);

  float collision = raymarch(rayOrigin, rayDirection);

  // If the ray collides, draw the surface
  if (collision > -0.5) {
    vec3 normal = getNormal(rayOrigin + rayDirection * collision);
    color = normal * 0.5 + 0.5;
  }

  gl_FragColor = vec4(color, 1);
}