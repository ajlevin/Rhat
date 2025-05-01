shader_type canvas_item;

uniform vec4 original_color1 : source_color;
uniform vec4 original_color2 : source_color;
uniform vec4 original_color3 : source_color;
uniform vec4 original_color4 : source_color;
uniform vec4 original_color5 : source_color;
uniform vec4 new_color1 : source_color;
uniform vec4 new_color2 : source_color;
uniform vec4 new_color3 : source_color;
uniform vec4 new_color4 : source_color;
uniform vec4 new_color5 : source_color;
uniform float tolerance : hint_range(0, 1);

vec4 swap_color(vec4 color){
	vec4 original_colors[5] = vec4[5] (original_color1, original_color2, original_color3, original_color4, original_color5);
	vec4 replace_colors[5] = vec4[5] (new_color1, new_color2, new_color3, new_color4, new_color5);
	for (int i = 0; i < 5; i ++) {
		if (distance(color, original_colors[i]) <= tolerance){
			return replace_colors[i];
		}
	}
	return color;
}

void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV));
}