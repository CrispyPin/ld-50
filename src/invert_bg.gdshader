shader_type canvas_item;

void fragment(){
	COLOR.a = texture(TEXTURE, UV).a;
	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	c = 1.0 - c;
	if (length(c - 0.5) < 0.2){
		c = vec3(0)
	}
	COLOR.rgb = c;
}