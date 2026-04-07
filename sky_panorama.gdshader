shader_type sky;

uniform sampler2D Image : source_color, filter_linear_mipmap, repeat_enable;
uniform float RotationAngle = 0.0;
uniform vec2 xy_offset = vec2(0.0);
uniform float Intensity : hint_range(0.0, 7.5) = 1.0;

void sky() {
	vec3 dir = normalize(EYEDIR);
	
	// Apply Y-axis rotation
	float s = sin(RotationAngle);
	float c = cos(RotationAngle);
	dir = vec3(c * dir.x + s * dir.z, dir.y, -s * dir.x + c * dir.z);
	
	// Convert direction to equirectangular UV
	float phi = atan(dir.x, dir.z);
	float theta = asin(clamp(dir.y, -1.0, 1.0));
	
	vec2 uv;
	uv.x = 0.5 - phi / TAU;
	uv.y = 0.5 - theta / PI;
	
	// Apply offset
	uv += xy_offset;
	
	vec3 col = textureLod(Image, uv, 0.0).rgb;
	COLOR = col * Intensity;
}
