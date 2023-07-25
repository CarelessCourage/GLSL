import { v, Vec2, Vec3 } from './vectors';
import { camera } from './camera';

export const registerRaymarch = `
  float raymarch(vec3 rayOrigin, vec3 rayDir) {
    const int steps = 90;
    const float maxdist = 20.0;
    const float precis = 0.001;

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
`

export const raymarch = (rayOrigin: Vec3, rayDirection: Vec3) => `raymarch(${v(rayOrigin)}, ${v(rayDirection)})`;

export const registerMarchHit = (onHit: Vec3) => `
  vec3 marchHit(vec2 screenPos) {
    vec3 color = vec3(0.0);

    vec3 rayOrigin = vec3(3.5, 0., 3.5);
    vec3 rayTarget = vec3(0, 0, 0);

    vec3 rayDirection = ${camera('rayOrigin', 'rayTarget', 'screenPos', 0.5)};
    float collision = ${raymarch('rayOrigin', 'rayDirection')};

    if (collision > -0.5) {
      color = ${onHit};
    }

    return color;
  }
`

export const marchHit = (screenPos: Vec2) => `marchHit(${v(screenPos)})`

export const registerScene = (SDFs: string) => {
  return `
    float scene(vec3 p) {
      return ${SDFs};
    }
  `;;
}