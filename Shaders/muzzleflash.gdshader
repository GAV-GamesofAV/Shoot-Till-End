shader_type canvas_item;

uniform vec3 target_color= vec3(0.2, 0.5, 1.0); // Blue tint
uniform bool preserve_brightness = true;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Desaturate the original color
    float brightness = dot(tex_color.rgb, vec3(0.333)); // Average or use vec3(0.299, 0.587, 0.114) for luminance

    vec3 final_color = preserve_brightness
        ? target_color * brightness
        : target_color;

    COLOR = vec4(final_color, tex_color.a);
}
