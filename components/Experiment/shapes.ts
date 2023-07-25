import { v, Vec2, Vec3 } from "./vectors";

export const subtract = (shape1: string, shape2: string) => `max(-${shape1}, ${shape2})`;
export const combine = (shape1: string, shape2: string)  => `min(${shape1}, ${shape2})`;
export const intersect = (shape1: string, shape2: string)  => `max(${shape1}, ${shape2})`;

export const sphere = (position: Vec3, radius: Number) => `(length(${position}) - ${radius})`;

export const registerTorus = `
  float sdTorus(vec3 p, vec2 t) {
    vec2 q = vec2(length(p.xz) -t.x, p.y);
    return length(q)-t.y;
  }
`;

export const torus = (position: Vec3, thickness: Vec2) => `sdTorus(${v(position)}, ${v(thickness)})`;

export const ring = (position: Vec3) => subtract(
  sphere(position, 1.15),
  torus(position, [1.0, 0.25])
);
