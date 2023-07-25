import { v, Vec2, Vec3 } from "./vectors";

export const registerCamera = `
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
`

export const camera = (rayOrigin: Vec3, rayTarget: Vec3, screenPos: Vec2, lensLength: Number | string) => `camera(${v(rayOrigin)}, ${v(rayTarget)}, ${v(screenPos)}, ${lensLength})`;
