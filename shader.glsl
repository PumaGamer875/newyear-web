///////////////////////////////////////////////////////////////
// 2025 → 2026 New Year Shader (FULL VERSION)
///////////////////////////////////////////////////////////////

#define S(a,b,c) smoothstep(a,b,c)

// ================== UTIL ==================

float box(vec2 p, vec2 b){
    vec2 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);
}

// ================== DIGITS ==================

float zeroDst(vec2 uv){
    uv.y -= 0.5;
    uv.y = pow(abs(uv.y),1.6)*sign(uv.y);
    return abs(length(uv)-0.72)-0.28;
}

float twoDst(vec2 uv){
    uv.y -= 0.5;
    float a = abs(length(uv)-0.72)-0.28;
    float cut = box(uv+vec2(0.0,0.2),vec2(0.8,0.4));
    return max(a,-cut);
}

float fiveDst(vec2 uv){
    uv.y -= 0.5;
    float a = abs(length(uv+vec2(0.0,0.4))-0.72)-0.28;
    float cut = box(uv+vec2(0.0,-0.2),vec2(0.8,0.4));
    return max(a,-cut);
}

// ---- SIX FIXED ----
float sixDst(vec2 uv){
    uv.y -= 0.5;

    vec2 p = uv + vec2(0.0, 0.55);
    p.y = pow(abs(p.y),1.4)*sign(p.y);
    float body = abs(length(p)-0.72)-0.28;

    vec2 q = uv + vec2(0.0,-0.25);
    q.y = pow(abs(q.y),1.6)*sign(q.y);
    float head = abs(length(q)-0.72)-0.28;

    float cut = box(uv + vec2(0.45,0.05),vec2(0.45,0.5));
    return max(min(body,head), -cut);
}

// ================== DRAWING ==================

vec4 border(vec3 color, float dist){
    float aa = 2.0 / iResolution.x;
    float a = S(0.25+aa, 0.25, dist);
    vec3 rgb = mix(color, vec3(a), S(0.1, 0.1+aa, dist));
    return vec4(rgb, a);
}

vec4 premulBlend(vec4 s, vec4 d){
    return vec4(d.rgb*(1.0-s.a)+s.rgb, 1.0-(1.0-s.a)*(1.0-d.a));
}

// ================== TRANSFORM ==================

vec2 letterUVs(vec2 uv, vec2 pos, float angle){
    float c = sin(angle), s = cos(angle);
    uv -= pos;
    return uv.x*vec2(s, c) + uv.y*vec2(-c, s);
}

// ================== COLORS ==================

vec3 purple  = vec3(0.58,0.12,0.89);
vec3 cyan    = vec3(0.00,0.82,0.89);
vec3 magenta = vec3(0.89,0.12,0.58);
vec3 teal    = vec3(0.12,0.89,0.58);
vec3 gold    = vec3(0.96,0.70,0.19);

// ================== CITY ==================

float hash21(vec2 p){
    return fract(sin(dot(p, vec2(27.619,57.583)))*43758.5453);
}

float building(vec2 uv, float x){
    float h = hash21(vec2(x,1.0)) * 1.2 + 0.3;
    float w = 0.06 + hash21(vec2(x,2.0)) * 0.05;
    float bx = smoothstep(w, w-0.01, abs(uv.x - x));
    float by = smoothstep(h, h-0.02, uv.y);
    return bx * by;
}

float city(vec2 uv){
    float c = 0.0;
    for(float i=-1.0;i<=1.0;i+=0.07){
        c = max(c, building(uv, i));
    }
    return c;
}

vec3 cityColor(vec2 uv){
    float c = city(uv);
    vec3 night = vec3(0.04,0.07,0.15);
    vec3 windows = vec3(1.0,0.85,0.55);
    return mix(night, windows, c*0.9);
}

// ================== TIME ==================

float secondsToNewYear(){
    float days = 365.0 - (iDate.y*30.5 + iDate.z);
    return days*86400.0 + (86400.0 - iDate.w);
}

// ================== YEARS ==================

vec4 draw2025(vec2 uv, float a){
    vec4 r = border(purple, twoDst(letterUVs(uv, vec2(-2.5,0),a)));
    r = premulBlend(border(cyan, zeroDst(letterUVs(uv, vec2(-0.8,0),a))), r);
    r = premulBlend(border(magenta, twoDst(letterUVs(uv, vec2(0.8,0),a))), r);
    r = premulBlend(border(teal, fiveDst(letterUVs(uv, vec2(2.5,0),a))), r);
    return r;
}

vec4 draw2026(vec2 uv, float a){
    vec4 r = border(purple, twoDst(letterUVs(uv, vec2(-2.5,0),a)));
    r = premulBlend(border(cyan, zeroDst(letterUVs(uv, vec2(-0.8,0),a))), r);
    r = premulBlend(border(magenta, twoDst(letterUVs(uv, vec2(0.8,0),a))), r);
    r = premulBlend(border(teal, sixDst(letterUVs(uv, vec2(2.5,0),a))), r);
    return r;
}

// ================== COUNTDOWN ==================

vec4 drawCountdown(vec2 uv, int n){
    float a = sin(iTime)*0.3;
    vec2 p = letterUVs(uv, vec2(0), a);

    float d = (n==0)?zeroDst(p):
              (n==1)?abs(p.x)-0.25:
              (n==2)?twoDst(p):
              (n==3)?abs(p.y)-0.25:
              (n==4)?abs(p.x)-0.2:
              (n==5)?fiveDst(p):
              (n==6)?sixDst(p):10.0;

    return border(gold, d);
}

// ================== MAIN ==================

void mainImage(out vec4 fragColor, in vec2 fragCoord){
    vec2 uv = (2.0*fragCoord-iResolution.xy)/iResolution.y * 3.0;

    float angle = sin(iTime)*0.3;
    float t = secondsToNewYear();

    vec3 bg = cityColor(uv*0.4 - vec2(0,1.1)) + vec3(0.1,0.0,0.2) + length(uv)*0.04;

    vec4 dateCol;

    if(iDate.x < 2026.0){
        if(t <= 10.0 && t > 0.0){
            int sec = int(ceil(t));
            dateCol = drawCountdown(uv, sec);
        }else{
            dateCol = draw2025(uv, angle);
        }
    }else{
        float anim = smoothstep(0.0,1.0,sin(iTime)*0.5+0.5);
        dateCol = premulBlend(draw2026(uv,angle)*anim, draw2025(uv,angle)*(1.0-anim));
    }

    vec3 col = premulBlend(dateCol, bg);
    col = pow(col, vec3(0.8));
    col = mix(col, col*1.4, 0.4);

    fragColor = vec4(col,1.0);
}
