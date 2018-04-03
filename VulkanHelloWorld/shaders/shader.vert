#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec3 inColor;
layout(location = 3) in vec2 inTexCoord;

layout(location = 0) out vec3 outColor;
layout(location = 1) out vec3 outNormal;
layout(location = 2) out vec2 outTexCoord;

out gl_PerVertex 
{
    vec4 gl_Position;
};

void main() 
{
    gl_Position = vec4(inPosition, 1.0);
    outColor = inColor;
	outNormal = inNormal;
	outTexCoord = inTexCoord;
}