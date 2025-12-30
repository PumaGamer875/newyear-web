precision highp float;

uniform vec2 iResolution;
uniform float iTime;

float box(vec2 p, vec2 b){
  vec2 d = abs(p)-b;
  return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float digit(vec2 p, int n){
  if(n==0) return abs(length(p)-0.4)-0.07;
  if(n==1) return box(p, vec2(0.05,0.4));
  if(n==2){
    float a=abs(length(p+vec2(0.0,0.2))-0.3)-0.07;
    float b=box(p+vec2(0.0,-0.2),vec2(0.35,0.05));
    return min(a,b);
  }
  if(n==5){
    float a=box(p+vec2(0.0,0.25),vec2(0.35,0.05));
    float b=box(p+vec2(-0.3,0.0),vec2(0.05,0.3));
    float c=box(p+vec2(0.0,-0.25),vec2(0.35,0.05));
    return min(a,min(b,c));
  }
  if(n==6){
    float a=abs(length(p+vec2(0.0,-0.1))-0.3)-0.07;
    float b=box(p+vec2(-0.3,0.1),vec2(0.05,0.3));
    return min(a,b);
  }
  return 1.0;
}

vec3 city(vec2 uv){
  vec3 col=vec3(0.02,0.04,0.1);
  float y=uv.y+0.5;
  for(int i=0;i<30;i++){
    float x=fract(sin(float(i)*13.3)*4375.5);
    float h=fract(sin(float(i)*7.7)*77.7)*0.6+0.2;
    float w=0.04;
    if(abs(uv.x-x+0.5)<w && y<h){
      col+=vec3(0.05,0.1,0.2);
    }
  }
  return col;
}

void main(){
  vec2 uv=(gl_FragCoord.xy-0.5*iResolution.xy)/iResolution.y;

  vec3 col=city(uv);

  float t = mod(floor(iTime), 10.0);
  int a=int(2);
  int b=int(0);
  int c=int(2);
  int d=int(t<5.0?5:6);

  vec2 p=uv;
  p.x+=1.2;
  float k=min(digit(p,a),1.0);
  p.x+=0.8; k=min(k,digit(p,b));
  p.x+=0.8; k=min(k,digit(p,c));
  p.x+=0.8; k=min(k,digit(p,d));

  float glow=exp(-k*40.0);
  col+=vec3(0.6,0.8,1.0)*glow;

  gl_FragColor=vec4(col,1.0);
}
