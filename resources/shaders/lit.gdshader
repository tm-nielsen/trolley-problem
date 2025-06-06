shader_type spatial;
render_mode diffuse_burley, cull_disabled;

uniform vec3 albedo_colour: source_color = vec3(1);
uniform sampler2D albedo_texture: hint_default_white, filter_nearest;

uniform float metallic: hint_range(0.0, 1.0) = 0;
uniform float specular: hint_range(0, 1) = 0.5;
uniform float roughness: hint_range(0.0, 1.0) = 0.5;

uniform vec3 emission: source_color = vec3(0);

uniform vec2 uv_scale = vec2(1);
uniform float normal_scale: hint_range(-1, 1, 2) = 1.0;

void vertex() {
	UV *= uv_scale;
	NORMAL *= normal_scale;
}

void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb * albedo_colour;

	ROUGHNESS = roughness;
	METALLIC = metallic;
	SPECULAR = specular;

	EMISSION = emission;
}