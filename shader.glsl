precision highp float;

uniform vec2 iResolution;
uniform float iTime;
uniform vec4 iDate;

void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    float r = 0.5 + 0.5*sin(iTime);
    float g = uv.x;
    float b = uv.y;

    gl_FragColor = vec4(r,g,b,1.0);
}
