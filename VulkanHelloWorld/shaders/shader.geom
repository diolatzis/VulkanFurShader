#version 450
#extension GL_ARB_separate_shader_objects : enable

#define FUR_LAYERS 1

#define FUR_LENGTH 0.2

layout(binding = 0) uniform UniformBufferObject 
{
    mat4 model;
    mat4 view;
    mat4 proj;
	vec3 eye;
} ubo;

//Inputs

layout(triangles_adjacency) in;

layout(location = 0) in vec3 inColor[6];
layout(location = 1) in vec3 inNormal[6];
layout(location = 2) in vec2 inTexCoord[6];

//Outputs

layout(triangle_strip, max_vertices = 30) out;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 fragTexCoord;
layout(location = 2) out float fragAlpha;

//Compute normal
vec3 getNormal(vec3 A, vec3 B, vec3 C)
{
	return normalize(cross(C-A,B-A));
}

void main() 
{

	/*//----------------- SHELLS CREATION -----------------//
	
	//The distnace between is shell layer
	const float FUR_DELTA = 1.0 / float(FUR_LAYERS);
	
	float dist = 0.0;

	//For each layer
	for(int layer = 0; layer < FUR_LAYERS ; layer++)
	{
		//Go through the actual vetices in positions 0,2,4 because of the topology
		for(int i = 0; i < gl_in.length(); i+=2)
		{
			fragAlpha = 1.0f-dist;			//The further the shell from the surface is the more transparent it is

			fragColor = inColor[i];			
			fragTexCoord = inTexCoord[i];			

			//Add a vertex away from the original one
			gl_Position = ubo.proj * ubo.view * ubo.model * ((gl_in[i].gl_Position) + vec4(inNormal[i] * dist * FUR_LENGTH, 0.0));

			EmitVertex();
		}

		//Create a primitive from the vertices
		EndPrimitive();

		dist += FUR_DELTA;
	}*/

	//----------------- FINS CREATION -----------------//

	//Current triangle world positions
	vec4 wp1 = ubo.model*gl_in[0].gl_Position;
	vec4 wp2 = ubo.model*gl_in[2].gl_Position;
	vec4 wp3 = ubo.model*gl_in[4].gl_Position;
	
	vec3 N = getNormal(wp1.xyz,wp2.xyz,wp3.xyz);			//Current triangle normal
	vec3 basePoint = ((wp1+wp2+wp3)/3.0f).xyz;				//Current triangle base point
	vec3 viewDirection = normalize(basePoint - ubo.eye);	//Vector from camera to base point

	float dotView = dot(N, viewDirection);					

	if(dotView < 0)			//Current triangle is front facing
	{

		for(int i =0; i < gl_in.length(); i+=2)		//For each of the adjacent triangles
		{
			int prevVer = (i+2)&6;					//The previous vertex using modulo

			//Adjacent triangle positions
			wp1 = ubo.model*gl_in[i].gl_Position;
			wp2 = ubo.model*gl_in[i+1].gl_Position;
			wp3 = ubo.model*gl_in[prevVer].gl_Position;

			//Similarly compute the dot view
			vec3 N = getNormal(wp1.xyz,wp2.xyz,wp3.xyz);
			vec3 basePoint = ((wp1+wp2+wp3)/3.0f).xyz;
			vec3 viewDirection = normalize(basePoint - ubo.eye);
			viewDirection = normalize(viewDirection);

			float dotView = dot(N, viewDirection);

			if(dotView >= 0)		//Adjacent triangle is back facing
			{
				fragAlpha = 1;
				fragColor = vec3(1.0,0.0,0.0);	//Red silhouettte
				fragTexCoord = inTexCoord[i];	//Because of lack of good fin texture use the same fur one	

				//Add the first triangle of the fin quad
				gl_Position = ubo.proj * ubo.view * ubo.model * gl_in[i].gl_Position;
				EmitVertex();
				gl_Position = ubo.proj * ubo.view * ubo.model * (gl_in[prevVer].gl_Position+vec4(inNormal[prevVer]*FUR_LENGTH,0.0));
				EmitVertex();
				gl_Position = ubo.proj * ubo.view * ubo.model * gl_in[prevVer].gl_Position;
				EmitVertex();
				EndPrimitive();

				//Add the second triangle of the fin quad
				gl_Position = ubo.proj * ubo.view * ubo.model * (gl_in[i].gl_Position+vec4(inNormal[i]*FUR_LENGTH,0.0));
				EmitVertex();
				gl_Position = ubo.proj * ubo.view * ubo.model * (gl_in[prevVer].gl_Position+vec4(inNormal[prevVer]*FUR_LENGTH,0.0));
				EmitVertex();
				gl_Position = ubo.proj * ubo.view * ubo.model * gl_in[i].gl_Position;
				EmitVertex();
	
				EndPrimitive();
			}

		}

	}

}