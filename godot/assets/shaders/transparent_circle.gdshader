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

global uniform vec3 player_pos;

void fragment(){
	vec4 tex_color = texture(albedo_texture, UV);
	ALBEDO = tex_color.rgb;
	
	vec3 player_view_pos = (VIEW_MATRIX * vec4(player_pos, 1.0)).xyz;
	float dist = distance(VERTEX.xy, player_view_pos.xy);
	float mask = smoothstep(mask_radius - feather, mask_radius, dist);

	float world_y = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y;

	if (VERTEX.z > player_view_pos.z + 1.0 && world_y > player_pos.y + 0.4) {
		// Bayer Ordered Dithering Matrix
		const mat4 dither_matrix = mat4(
			vec4(0.0625, 0.5625, 0.1875, 0.6875),
			vec4(0.8125, 0.3125, 0.9375, 0.4375),
			vec4(0.25, 0.75, 0.125, 0.625),
			vec4(1.0, 0.5, 0.875, 0.375)
		);

		int x = int(FRAGCOORD.x) % 4;
		int y = int(FRAGCOORD.y) % 4;

		if (mask < dither_matrix[x][y]) {
			discard;
		}
	}
}

//void fragment() {
    //// If the distance is less than 10 meters, turn the wall red.
    //// This removes all complex dithering math and focuses only on the variable.
    //float dist = distance(NODE_POSITION_WORLD + VERTEX, NODE_POSITION_WORLD + player_pos); //vec3(4.0, -6.0, -4.0)
    //
    //if (dist < 5.0 && ena) {
        //ALBEDO = vec3(1.0, 0.0, 0.0);
    //} else {
        //ALBEDO = vec3(0.0, 1.0, 0.0); // Green otherwise
    //}
//}
