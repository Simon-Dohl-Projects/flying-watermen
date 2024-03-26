shader_type canvas_item;

uniform float blink_speed = 1.0;
uniform bool blink_toogle = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (blink_toogle){
		vec4 color = texture(TEXTURE, UV);

		float blink = 0.2 + 0.6 * abs(sin(TIME * blink_speed));

		color.a *= abs(blink);
		COLOR = color;
	}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
