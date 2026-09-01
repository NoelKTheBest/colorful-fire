shader_type canvas_item;

const vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool make_white = false;


//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	
	if (texture(TEXTURE, UV).a > 0.0 && make_white)
	{
		COLOR = white;
	}
	else
	{
		COLOR = texture(TEXTURE, UV);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
