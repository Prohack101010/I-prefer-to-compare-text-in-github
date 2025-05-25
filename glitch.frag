#pragma header
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform bool enabled;
float hash(vec2 p) {
	float h = dot(p,vec2(127.1,311.7));
	return -1.0 + 2.0*fract(sin(h)*43758.5453123);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	vec2 u = f*f*(3.0-2.0*f);

	return mix(mix(hash( i + vec2(0.0,0.0) ), 
		hash( i + vec2(1.0,0.0) ), u.x),
	mix( hash( i + vec2(0.0,1.0) ), 
		hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

float noise(vec2 p, int oct) {
	mat2 m = mat2( 1.6,  1.2, -1.2,  1.6 );
	float f  = 0.0;

	for(int i = 1; i < 3; i++){
		float mul = 1.0/pow(2.0, float(i));
		f += mul*noise(p); 
		p = m*p;
	}

	return f;
}

void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    if (!enabled) {
        gl_FragColor = flixel_texture2D(bitmap, uv);
        return;
    }
	vec2 uv2 = fragCoord.xy / iResolution.xy;

     float glitch = pow(cos(iTime*0.5)*1.0, 0.0);
    
    
    if(noise(iTime+vec2(0, 0))*glitch > 0.70){
		uv2.y = mod(uv2.y+noise(vec2(iTime*1.0, 0)), 1.0);
	}


	vec2 hp = vec2(0.0, uv2.y);
	float nh = noise(hp*1.0+iTime*1.0, 3) * (noise(hp+iTime*0.3)*0.3);
	nh += noise(hp*100.0+iTime*10.0, 1)*0.02;
	float rnd = 0.0;
	if(glitch > 0.0){
		rnd = hash(uv2);
		if(glitch < 1.0){
			rnd *= glitch;
		}
	}
	nh *= glitch + rnd;
	float r = texture(iChannel0, uv2+vec2(nh, 0.08)*nh).r;
	float g = texture(iChannel0, uv2+vec2(nh-0.07, 0.0)*nh).g;
	float b = texture(iChannel0, uv2+vec2(nh, 0.0)*nh).b;

	vec3 col = vec3(r, g, b);
	fragColor = vec4(col.rgb, flixel_texture2D(bitmap, uv2).a);
}

