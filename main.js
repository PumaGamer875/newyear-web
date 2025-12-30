const canvas = document.getElementById("gl");
const gl = canvas.getContext("webgl");

canvas.width = innerWidth;
canvas.height = innerHeight;

const vert = `
attribute vec2 p;
void main() {
  gl_Position = vec4(p,0,1);
}
`;

async function loadShader() {
  const frag = await fetch("shader.glsl").then(r => r.text());

  const program = gl.createProgram();

  function compile(type, src) {
    const s = gl.createShader(type);
    gl.shaderSource(s, src);
    gl.compileShader(s);
    return s;
  }

  gl.attachShader(program, compile(gl.VERTEX_SHADER, vert));
  gl.attachShader(program, compile(gl.FRAGMENT_SHADER, frag));
  gl.linkProgram(program);
  gl.useProgram(program);

  const buf = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buf);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
    -1,-1, 1,-1, -1,1,
    -1,1, 1,-1, 1,1
  ]), gl.STATIC_DRAW);

  const loc = gl.getAttribLocation(program, "p");
  gl.enableVertexAttribArray(loc);
  gl.vertexAttribPointer(loc,2,gl.FLOAT,false,0,0);

  const timeLoc = gl.getUniformLocation(program, "iTime");
  const resLoc  = gl.getUniformLocation(program, "iResolution");
  const dateLoc = gl.getUniformLocation(program, "iDate");

  function frame(t) {
    const now = new Date();
    const seconds =
      now.getHours()*3600 +
      now.getMinutes()*60 +
      now.getSeconds();

    gl.uniform1f(timeLoc, t*0.001);
    gl.uniform2f(resLoc, canvas.width, canvas.height);
    gl.uniform4f(dateLoc,
      now.getFullYear(),
      now.getMonth()+1,
      now.getDate(),
      seconds
    );

    gl.drawArrays(gl.TRIANGLES,0,6);
    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
}

loadShader();
