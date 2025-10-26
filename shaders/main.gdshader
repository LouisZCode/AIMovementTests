shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec4 color = texture(screen_tex, SCREEN_UV);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    COLOR = vec4(vec3(gray), color.a);
}