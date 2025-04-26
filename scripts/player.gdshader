shader_type canvas_item;

uniform vec4 target_color : source_color;
uniform vec4 new_color : source_color;
uniform float tolerance : hint_range(0, 1);

void fragment() {
	vec4 curPixColor = texture(TEXTURE, UV);
	float dist = distance(curPixColor.rgb, target_color.rgb);
	
	if (dist < tolerance) {
		curPixColor.rgb = new_color.rgb;
	}
	
	COLOR = curPixColor;
}