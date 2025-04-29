shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform sampler2D overlay;
uniform float multiplier: hint_range(0.0, 1.0, 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 layer = texture(overlay, SCREEN_UV);
	if (layer != vec4(1.0, 1.0, 1.0, 1.0)) {
		ALBEDO = layer.rgb;
		ALPHA = layer.a * multiplier;
	}
	else {
		ALPHA = 0.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
