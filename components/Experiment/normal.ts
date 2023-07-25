import { v, Vec3 } from './vectors';

export const registerGetNormal = `
  vec3 getNormal(vec3 p) {
    vec2 o = vec2(0.001, 0.0);
    return normalize(vec3(
      scene(p + o.xyy) - scene(p - o.xyy),
      scene(p + o.yxy) - scene(p - o.yxy),
      scene(p + o.yyx) - scene(p - o.yyx)
    ));
  }
`

export const getNormal = (position: Vec3) => `getNormal(${v(position)})`;