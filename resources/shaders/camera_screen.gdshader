shader_type canvas_item;

uniform float edge_margin: hint_range(0.5, 1) = 0.5;
uniform float distortion_amount: hint_range(1, 4) = 1.5;

void fragment() {
	vec2 uv_offset = UV - vec2(0.5);
	float average_offset = length(2.0 * uv_offset);

	float x = 2.0 * abs(0.5 - UV.x);
	x *= x * x;
	float y = 2.0 * abs(0.5 - UV.y);
	y *= y * y;

	float e = (x + y) / 2.0;

	float distortion = 1.0 + pow(average_offset, distortion_amount);
	vec2 uv = vec2(0.5) + uv_offset * (distortion) * 0.5;
	COLOR.rgb = texture(TEXTURE, uv).rgb;

	COLOR.rgb *= step(e, 1.0 - edge_margin);
}
