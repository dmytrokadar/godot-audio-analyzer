shader_type spatial;
//render_mode blend_mix;
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//void fragment() {
	//// Called for every pixel the material is visible on.
//}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

// The size of the hole
uniform sampler2D albedo_texture : source_color;
uniform float mask_radius = 2.5;
uniform float feather = 0.5;

// Godot automatically fills this from our Global Shader Parameter
global uniform vec3 player_pos;

void fragment(){
	vec4 tex_color = texture(albedo_texture, UV);
	ALBEDO = tex_color.rgb;
    // Calculate distance between this pixel and the player
    float dist = distance(NODE_POSITION_WORLD + VERTEX, player_pos);
    
    // Create a smooth mask: 0.0 inside the hole, 1.0 outside
    float mask = smoothstep(mask_radius - feather, mask_radius, dist);
    
    // Dithering pattern logic
    // We use a 4x4 matrix to decide which pixels to 'discard'
    const mat4 dither_matrix = mat4(
        vec4(0.0625, 0.5625, 0.1875, 0.6875),
        vec4(0.8125, 0.3125, 0.9375, 0.4375),
        vec4(0.25, 0.75, 0.125, 0.625),
        vec4(1.0, 0.5, 0.875, 0.375)
    );
    
    // Get current pixel coordinates for the matrix
    int x = int(FRAGCOORD.x) % 4;
    int y = int(FRAGCOORD.y) % 4;
    
    // If the mask value is lower than our dither threshold, delete the pixel
    if (mask < dither_matrix[x][y]) {
        discard;
    }
}
