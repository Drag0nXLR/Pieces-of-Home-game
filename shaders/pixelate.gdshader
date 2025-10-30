shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 1000.0) = 1.0;

void fragment() {
    // uv текстури TextureRect
    vec2 uv = UV;

    // округляємо координати до розміру пікселя
    vec2 pixel_uv = floor(uv * pixel_size) / pixel_size;

    // беремо колір з текстури
    COLOR = texture(TEXTURE, pixel_uv);
}
