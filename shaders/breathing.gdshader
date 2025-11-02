shader_type canvas_item;

uniform float breath_strength = 0.05;
uniform float breath_speed = 1.5;
uniform vec2 face_center = vec2(0.5, 0.5);
uniform float face_radius = 0.5;

varying vec4 modulate;

void vertex() {
    modulate = COLOR;
}

float circle_mask(vec2 uv, vec2 center, float radius) {
    float d = distance(uv, center);
    return 1.0 - smoothstep(radius * 0.6, radius, d);
}

void fragment() {
    vec2 uv = UV;

    // Breathing effect - vertical displacement based on distance from center
    float center_dist = abs(uv.y - 0.5);
    float breath = sin(TIME * breath_speed) * breath_strength;

    // Apply more displacement near the chest area (middle of sprite)
    float chest_mask = 1.0 - (center_dist * 2.0);
    chest_mask = clamp(chest_mask, 0.0, 1.0);

    vec2 breath_disp = vec2(0.0, breath * chest_mask);
    vec2 final_uv = uv + breath_disp;

    // Sample the texture with displaced UVs
    COLOR = texture(TEXTURE, final_uv) * modulate;
}
