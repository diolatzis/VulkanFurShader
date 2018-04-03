#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 fragTexCoord;
layout(location = 2) in float fragAlpha;

layout(location = 0) out vec4 outColor;

layout(binding = 1) uniform sampler2D texSampler;

void main() 
{
   
	//outColor = vec4(texture(texSampler, fragTexCoord).rgb, fragAlpha);		//Draw with textures

	outColor = vec4(fragColor, fragAlpha);	//Draw colors for silhouette (FUR_LAYERS must be below 8 for the silhouette to show)
}