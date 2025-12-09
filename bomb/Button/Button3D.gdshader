shader_type spatial;

//uniform float r : hint_range(0.0, 1.0, 1/256);
//uniform float g : hint_range(0.0, 1.0, 1/256);
//uniform float b : hint_range(0.0, 1.0, 1/256);
void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO.r = 0.67;
	ALBEDO.g = .01;
	ALBEDO.b = .01;
	
	//ALBEDO.t = -1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
