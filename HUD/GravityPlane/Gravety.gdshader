shader_type spatial;

uniform int n_bodys;
uniform vec3[100] bodysPos;
uniform float[100] bodyMass;

void vertex() {	
	vec3 wrld_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	float F = 0.0;
	for (int i = 0; i<=n_bodys; i++){	
		vec3 D = wrld_vertex - bodysPos[i] ;			
		float d2 = D.x*D.x + D.z*D.z +1.0 ;		
		F = F + (50.0 * (bodyMass[i] / d2)*1000.0) ;
	}
	
	VERTEX.y = -F;
	COLOR.xyz = vec3(F/100.0);
	//COLOR.x = 0.8;
}

void fragment(){
  ALBEDO = COLOR.xyz;
	//ALPHA = COLOR.x;
}