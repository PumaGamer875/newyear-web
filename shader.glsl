precision highp float;

uniform vec2 iResolution;
uniform float iTime;

// =================== UTILIDADES ===================

float hash(float n){ return fract(sin(n)*43758.5453123); }

float noise(vec2 p){
    vec2 i=floor(p), f=fract(p);
    f=f*f*(3.-2.*f);
    float n=i.x+i.y*57.;
    return mix(mix(hash(n+0.),hash(n+1.),f.x),
               mix(hash(n+57.),hash(n+58.),f.x),f.y);
}

// =================== CIUDAD ===================

vec3 city(vec2 uv){
    vec3 col=vec3(0.02,0.03,0.08);
    uv.x*=4.0;

    for(int i=0;i<60;i++){
        float x=float(i)/60.;
        float h=hash(float(i)*3.1)*0.6+0.15;
        float w=0.03;
        if(abs(uv.x-(x*2.-1.))<w && uv.y+0.5<h){
            float windows=step(0.5,noise(vec2(i*10.,uv.y*40.)));
            col+=mix(vec3(0.05,0.1,0.2),vec3(1.0,0.8,0.4),windows);
        }
    }
    return col;
}

// =================== DÍGITOS ===================

float sdBox(vec2 p, vec2 b){
    vec2 d=abs(p)-b;
    return length(max(d,0.0))+min(max(d.x,d.y),0.0);
}

float digit(vec2 p, int n){
    p*=1.3;
    if(n==0) return abs(length(p)-0.35)-0.07;
    if(n==1) return sdBox(p,vec2(0.06,0.45));
    if(n==2) return min(abs(length(p+vec2(0.,0.2))-0.3)-0.07,
                         sdBox(p+vec2(0.,-0.2),vec2(0.35,0.05)));
    if(n==5) return min(sdBox(p+vec2(0.,0.3),vec2(0.35,0.05)),
                    min(sdBox(p+vec2(-0.3,0.),vec2(0.05,0.3)),
                        sdBox(p+vec2(0.,-0.3),vec2(0.35,0.05))));
    if(n==6) return min(abs(length(p+vec2(0.,-0.05))-0.3)-0.07,
                         sdBox(p+vec2(-0.28,0.05),vec2(0.06,0.32)));
    return 1.0;
}

// =================== ESCENA ===================

void main(){
    vec2 uv=(gl_FragCoord.xy-0.5*iResolution.xy)/iResolution.y;

    // Cielo
    vec3 col=mix(vec3(0.02,0.02,0.08),vec3(0.0,0.0,0.15),uv.y+0.5);

    // Ciudad
    col+=city(uv);

    // Tiempo real del sistema
    float sec=mod(iTime,60.);
    float t=clamp((sec-55.)/5.,0.,1.); // transición 5s

    int A=2, B=0, C=2;
    int D=mix(5.,6.,t)>5.5?6:5;

    vec2 p=uv;
    p.x+=1.5;
    float d=min(digit(p,A),1.);
    p.x+=0.9; d=min(d,digit(p,B));
    p.x+=0.9; d=min(d,digit(p,C));
    p.x+=0.9; d=min(d,digit(p,D));

    float glow=exp(-d*40.);
    vec3 neon=mix(vec3(0.3,0.7,1.0),vec3(1.0,0.3,0.5),t);

    col+=neon*glow*1.8;

    gl_FragColor=vec4(col,1.0);
}
