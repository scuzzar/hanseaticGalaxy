shader_type spatial;
//render_mode unshaded;
uniform sampler2D texture_albedo : hint_albedo;
uniform float cavety_distance;
uniform float cavety_transparence;

uniform float roughness = 1;
uniform float metallic = 0;


uniform bool draw_wire;
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void fragment() {
	float amount = cavety_distance;
	
	vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
		
	vec4 pass1 = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	float result = 1.0;
	
	int n_sample = 100*int(cavety_distance);
	
	for (int i = 0; i < n_sample; i++) {
		float x = rand(vec2(SCREEN_UV.x+float(i)+7.,SCREEN_UV.y+float(i)));
		float y = rand(vec2(SCREEN_UV.x-float(i)*5.,SCREEN_UV.y-float(i))*2.);

		//if(!(x*x+y*y>amount*amount)){
			vec2 offset = vec2(x*pixel_size.x,y*pixel_size.y);		
			vec4 sample = texture(SCREEN_TEXTURE, SCREEN_UV +offset*amount );
			if(length(sample-pass1)<0.1) {
				result -= 1./float(n_sample);
			}
		//}
	}
	
	float alpha = 0.;
	
	if(draw_wire){
	
	float d = 0.1;
	float w =d*pixel_size.x;
	float h = d*pixel_size.y;
		
	vec4 n0 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2( -w, -h));
	vec4 n1 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -h));
	vec4 n2 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(  w, -h));
	vec4 n3 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2( -w, 0.0));
	vec4 n4 = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 n5 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(  w, 0.0));
	vec4 n6 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2( -w, h));
	vec4 n7 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, h));
	vec4 n8 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(  w, h));
	vec4 sobel_edge_h = n2 + (2.0*n5) + n8 - (n0 + (2.0*n3) + n6);
	vec4 sobel_edge_v = n0 + (2.0*n1) + n2 - (n6 + (2.0*n7) + n8);
		
	vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));
		
	alpha = sobel.r;
    alpha += sobel.g;
	alpha +=  sobel.b;
    alpha /= 3.0;
	alpha;
	}
	vec4 albedo_tex = texture(texture_albedo,UV);
	
	albedo_tex.rgb = mix(pow((albedo_tex.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),albedo_tex.rgb.rgb * (1.0 / 12.92),lessThan(albedo_tex.rgb,vec3(0.04045)));
	ALBEDO = albedo_tex.rgb;
	//ALBEDO = vec3(result);
	ALBEDO *= 1.-(result*(1.-cavety_transparence));
	
	METALLIC = metallic;
	ROUGHNESS = roughness;

	if(draw_wire) EMISSION = vec3(alpha*0.1);	
}