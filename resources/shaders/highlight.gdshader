shader_type spatial;
render_mode unshaded;

uniform float scale = 1.5;

uniform vec4 colour: source_color = vec4(1);
uniform sampler2D colour_texture: hint_default_white;

void vertex() {
	VERTEX *= scale;
}

void fragment() {
	vec4 col = colour * texture(colour_texture, UV);
	ALBEDO = col.rgb;
	ALPHA = col.a;
}