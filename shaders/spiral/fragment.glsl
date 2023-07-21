// fragment.glsl
//precision mediump float;
uniform float uTime;
uniform vec2 resolution;

varying float vPattern;
varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;

// Version 3 ( possibly the fastest version, using a mix instead of a ternary operator ):

/* ** ColorStop Point data structure for the COLOR_RAMP macro 
color -> the color of the color stop
position -> position of the color stop on the color ramp -> [0, 1]
*/
struct ColorStop {
    vec3 color;
    float position;
};

/* ** COLOR_RAMP macro by Arya Ross -> based on Blender's ColorRamp Node in the shading tab
ColorStop[?] colors -> array of color stops that can have any length
float factor -> the position that you want to know the color of -> [0, 1]
vec3 finalColor -> the final color based on the factor 

Line 5 Of The Macro:
// possibly is bad for performance 
index = isInBetween ? i : index; \

Taken From: https://stackoverflow.com/a/26219603/19561482 
index = int(mix(float(index), float(i), float(isInBetween))); \
*/
#define COLOR_RAMP(colors, factor, finalColor) { \
    int index = 0; \
    for(int i = 0; i < colors.length() - 1; i++){ \
       ColorStop currentColor = colors[i]; \
       bool isInBetween = currentColor.position <= factor; \
       index = int(mix(float(index), float(i), float(isInBetween))); \
    } \
    ColorStop currentColor = colors[index]; \
    ColorStop nextColor = colors[index + 1]; \
    float range = nextColor.position - currentColor.position; \
    float lerpFactor = (factor - currentColor.position) / range; \
    finalColor = mix(currentColor.color, nextColor.color, lerpFactor); \
} \

// ------------------------------------------------

void main() {
    //vec2 uv = vUv;
    float time = uTime;
    vec3 color;

    vec3 mainColor = vec3(0.1, 0.4, 0.9);

    mainColor.r *=  0.9 + sin(time) / 3.2;
    mainColor.g *=  1.1 + cos(time / 2.0) / 2.5;
    mainColor.b *=  0.8 + sin(time / 5.0) / 4.0;

    ColorStop[3] colors = ColorStop[](
        ColorStop(mainColor / clamp(sin(uTime) * 2.0, 0.2, 4.0), 0.0),
        ColorStop(mainColor, 0.5),
        ColorStop(vec3(1.0), 1.0)
    );

    COLOR_RAMP(colors, vPattern, color);
    //gl_FragColor = vec4(vec3(step(0.5, fract(uv.y * 10))), 1.0)
    //gl_FragColor = vec4(1.0, vUv.y, 0.5, 1.0);
    gl_FragColor = vec4(color, 1.0);
    
}