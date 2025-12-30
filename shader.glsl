precision highp float;

uniform vec2 iResolution;
uniform float iTime;
uniform vec4 iDate;

float rand(vec2 p){return fract(sin(dot(p,vec2(12.9898,78.233)))*43758.5453);}

float digit(vec2 uv, int d){
    uv=abs(uv-0.5);
    float s=0.08;
    if(d==0) return step(max(uv.x,uv.y),0.45)-step(max(uv.x,uv.y),0.35);
    if(d==1) return step(uv.x,0.1)*step(uv.y,0.45);
    if(d==2) return step(uv.y,0.45)*step(abs(uv.y-0.25)+uv.x,0.45);
    if(d==3) return step(uv.y,0.45)*step(abs(uv.y-0.25)+abs(uv.x-0.25),0.45);
    if(d==4) return step(abs(uv.x-0.4),s)*step(uv.y,0.45);
    if(d==5) return step(uv.y,0.45)*step(abs(uv.y-0.25)+abs(uv.x-0.2),0.45);
    if(d==6) return step(uv.y,0.45)*step(max(abs(uv.x-0.25),abs(uv.y-0.25)),0.45);
    if(d==7) return step(uv.y,0.45)*step(uv.x,0.4);
    if(d==8) return step(max(abs(uv.x-0.25),abs(uv.y-0.25)),0.45);
    if(d==9) return step(uv.y,0.45)*step(abs(uv.x-0.25)+abs(uv.y-0.25),0.45);
    return 0.;
}

void main(){
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec3 col = vec3(0.02,0.03,0.08);

    // 🌆 Ciudad
    for(int i=0;i<40;i++){
        float x=float(i)/40.;
        float h=0.15+rand(vec2(i,0.))*0.4;
        if(uv.x>x && uv.x<x+0.02 && uv.y<h)
            col+=vec3(0.05);
    }

    // 🎇 Fuegos artificiales
    for(int i=0;i<6;i++){
        float t=iTime*0.5+float(i)*10.;
        vec2 p=vec2(rand(vec2(i,1.)),rand(vec2(i,2.)));
        float d=length(uv-p);
        col+=0.05/d*vec3(rand(p),rand(p+1.),1.);
    }

    // 🕒 Cuenta regresiva
    float total = 24.*3600. - iDate.w;
    int s = int(mod(total,60.));
    int m = int(mod(total/60.,60.));
    int h = int(total/3600.);

    vec2 p=uv*6.-vec2(1.5,0.5);
    float show=0.;
    show+=digit(fract(p),h/10);
    show+=digit(fract(p-vec2(1.,0.)),h%10);
    show+=digit(fract(p-vec2(2.,0.)),m/10);
    show+=digit(fract(p-vec2(3.,0.)),m%10);
    show+=digit(fract(p-vec2(4.,0.)),s/10);
    show+=digit(fract(p-vec2(5.,0.)),s%10);

    col = mix(col, vec3(1.,0.8,0.2), show);

    // ✨ Transición de año
    if(iDate.x>=2026.) col+=vec3(0.4,0.2,0.6);

    gl_FragColor = vec4(col,1.);
}
