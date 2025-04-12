shader_type canvas_item;

uniform vec3 solid_color:source_color;
uniform float amount: hint_range(0.0,1.0);
varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
    COLOR = vec4(mix(vertex_color.rgb, solid_color, amount), vertex_color.a);
}