shader_type canvas_item;
global uniform vec2 g_resolution;

const vec3 BROWN = vec3(0.4,0.2,0.0);
const vec3 GREEN = vec3(0.3, 0.5, 0.0);

uniform float xExtent1 = 0;
uniform float yExtent1 = 0;
uniform float xPos1 = 0;
uniform float yPos1 = 0;

uniform float xExtent2 = 0;
uniform float yExtent2 = 0;
uniform float xPos2 = 0;
uniform float yPos2 = 0;

uniform bool button1Hover = false;
uniform bool button2Hover = false;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sdfCircle( vec2 p, float r )
{
    return length(p) - r;
}

float opOnion(float d, float r) {
	return abs(d) - r;
}

float saturate(float t){
  return clamp(t, 0.0, 1.0);
}

float sinTaylor(float t){
	return t - t*t*t/6.0 + t*t*t*t*t/120.0 - t*t*t*t*t*t*t/5040.0 + t*t*t*t*t*t*t*t*t/362880.0;
}

float cosTaylor(float t){
	return 1.0 - t*t/2.0 + t*t*t*t/24.0 - t*t*t*t*t*t/720.0 + t*t*t*t*t*t*t*t/40320.0;;
}

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

vec3 BackgroundColour(vec2 p){
  float distFromCenter = abs(length(p - 0.5));

  float vignette = 1.0 - distFromCenter;
  vignette = smoothstep(0.0, 0.7, vignette);
  vignette = remap(vignette, 0.0, 1.0, 0.3, 1.0);

  return vec3(vignette);
}

float sdBox2( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;

	float xting = mod(p.y/8.0 + sign(p.x)*5.0*TIME, 2.0*PI) - PI;
	float yting = mod(p.x/8.0 - sign(p.y)*5.0*TIME, 2.0*PI) - PI;
    return length(max(d,0.0)) + min(max(d.x- (8.0 - 0.1*sign(p.y)*p.y*sin(TIME))*sinTaylor(xting),d.y - (8.0 - 0.1*sign(p.x)*p.x*cos(TIME))*cosTaylor(yting)),0.0);
	//float yting = mod(p.x + TIME, 2.0*PI) - PI;
    //return length(max(d,0.0)) + min(max(d.x,yting),0.0);

	//float yting = mod(d.y- 1.0*sin(p.x + TIME), 2.0*PI) - PI;
    //return length(max(d,0.0)) + min(max(d.x,yting),0.0);
}

float sdBox3( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;

	float xting = mod(p.y/8.0 + sign(p.x)*5.0*TIME, 2.0*PI) - PI;
	float yting = mod(p.x/8.0 - sign(p.y)*5.0*TIME, 2.0*PI) - PI;
    return length(max(d,0.0)) + min(max(d.x- 8.0*sinTaylor(xting),d.y - 8.0*cosTaylor(yting)),0.0);
	//float yting = mod(p.x + TIME, 2.0*PI) - PI;
    //return length(max(d,0.0)) + min(max(d.x,yting),0.0);

	//float yting = mod(d.y- 1.0*sin(p.x + TIME), 2.0*PI) - PI;
    //return length(max(d,0.0)) + min(max(d.x,yting),0.0);
}

vec3 DrawBackground(vec2 vUvs){
  vec3 morning = mix(
    vec3(0.44, 0.64, 0.84),
    vec3(0.34, 0.51, 0.94),
    smoothstep(0.0, 1.0, pow(vUvs.x * vUvs.y, 0.5))
  );

  return morning;
}
float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

float opSubtraction( float d1, float d2 )
{
    return max(-d1,d2);
}

void fragment() {
	vec2 pixelCoords = (UV - 0.5)*g_resolution;

	COLOR = vec4(DrawBackground(UV),1.0);


    float sun = sdfCircle(pixelCoords - vec2(
		230.0-10.0*sin(2.0*TIME + 1.0)+ 20.0*sin(TIME/2.0 + 2.0),
		70.0-30.0*sin(TIME + 1.0)+ 50.0*sin(2.0*TIME/3.0 + 2.0)),
		 4.0);
    //COLOR.rgb = mix(vec3(0.9, 0.85, 0.47), COLOR.rgb, smoothstep(0.0,100.0, sun));
	COLOR.rgb = mix(vec3(1.0)-vec3(0.7, 0.65, 0.27), COLOR.rgb, smoothstep(0.0,100.0, sun));
    float s = max(0.0001, sun);
    float p = saturate(exp(-0.0001 *(5.0 + 3.0*sin(TIME))/3.0* s * s));

    //COLOR.rgb += 0.5 * mix(vec3(0.0), vec3(0.9, 0.85, 0.47), p);
	COLOR.rgb -= 0.5 * mix(vec3(1.5),vec3(0.0)-vec3(0.7, 0.65, 0.27), p);

	//float background = sdCircle(pixelCoords - vec2(200,2000), 2000);
	//COLOR = mix(vec4(GREEN, 1.0), COLOR, step(0, background));
	vec3 buttonColor = vec3(0.3 +0.0125*sin(TIME), 0.0, 0.3+ 0.01*cos(TIME/2.0));
	vec3 hoverColor = 1.5 * buttonColor;
	float box1 = sdBox2(pixelCoords - vec2(xPos1, yPos1), vec2(xExtent1, yExtent1));
	float border1 = sdBox3(pixelCoords - vec2(xPos1, yPos1), vec2(120.0 + 3.0*sin(TIME), 35.0 + 3.0*sin(TIME)));
	border1 = opOnion(border1, 1);
	if(!button1Hover){
		COLOR = mix(vec4(buttonColor, 1.0), COLOR, step(0.0, box1));
	} else{
		COLOR = mix(vec4(hoverColor, 1.0), COLOR, step(0.0, box1));
	}

	COLOR = mix(vec4(1.0), COLOR, step(0, border1));

	float box2 = sdBox2(pixelCoords - vec2(xPos2, yPos2), vec2(xExtent2, yExtent2));
	float border2 = sdBox3(pixelCoords - vec2(xPos2, yPos2), vec2(120.0 + 3.0*sin(TIME), 35.0 + 3.0*sin(TIME)));
	border2 = opOnion(border2, 1);
	if(!button2Hover){
		COLOR = mix(vec4(buttonColor, 1.0), COLOR, step(0.0, box2));
	} else{
		COLOR = mix(vec4(hoverColor, 1.0), COLOR, step(0.0, box2));
	}
	COLOR = mix(vec4(1.0), COLOR, step(0, border2));


}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
