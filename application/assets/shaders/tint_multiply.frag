#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 tint;
};

void main() {
    vec4 c = texture(source, qt_TexCoord0);
    // Multiply RGB by the tint, keep alpha: white -> tint, black -> black.
    fragColor = vec4(c.rgb * tint.rgb, c.a) * qt_Opacity;
}
