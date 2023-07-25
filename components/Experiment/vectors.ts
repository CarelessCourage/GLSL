import { Vector4, Vector3, Vector2 } from 'three';

export type Vec4 = Vector4 | string | [number, number, number, number];
export type Vec3 = Vector3 | string | [number, number, number];
export type Vec2 = Vector2 | string | [number, number];
export type Vector = Vec4 | Vec3 | Vec2;

export function v(value: Vector) {
  // Converts JS arrays to GLSL vectors
  const isArray = Array.isArray(value);
  const length = isArray ? value.length : 1;

  if (!isArray && typeof value !== "string") {
    return value;
  }

  switch (length) {
    case 2:
      return `vec2(${value[0]}, ${value[1]})`;
    case 3:
      return `vec3(${value[0]}, ${value[1]}, ${value[2]})`;
    case 4:
      return `vec4(${value[0]}, ${value[1]}, ${value[2]}, ${value[3]})`;
    default:
      return value; // Return the value as is if it's not a valid vector representation
  }
}