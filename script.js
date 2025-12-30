// ====== THREE.JS CITY ======

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(60, innerWidth/innerHeight, 0.1, 1000);
camera.position.set(0, 10, 25);

const renderer = new THREE.WebGLRenderer({ antialias:true });
renderer.setSize(innerWidth, innerHeight);
document.getElementById("scene").appendChild(renderer.domElement);

addEventListener("resize", ()=>{
  camera.aspect = innerWidth/innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(innerWidth, innerHeight);
});

// Lights
scene.add(new THREE.AmbientLight(0x6060ff, 1));
const light = new THREE.DirectionalLight(0xffffff, 1);
light.position.set(10, 20, 10);
scene.add(light);

// Ground
const ground = new THREE.Mesh(
  new THREE.PlaneGeometry(200,200),
  new THREE.MeshStandardMaterial({ color:0x020212 })
);
ground.rotation.x = -Math.PI/2;
scene.add(ground);

// Buildings
for(let i=0;i<350;i++){
  const h = Math.random()*15+3;
  const mat = new THREE.MeshStandardMaterial({
    color: 0x0b1b3a,
    emissive: 0x2233ff,
    emissiveIntensity: Math.random()*0.6 + 0.3
  });

  const b = new THREE.Mesh(
    new THREE.BoxGeometry(1.5, h, 1.5),
    mat
  );

  b.position.set((Math.random()-0.5)*90, h/2, (Math.random()-0.5)*90);
  scene.add(b);
}


function animate(){
  requestAnimationFrame(animate);
  camera.position.x = Math.sin(Date.now()*0.0002)*10;
  camera.lookAt(0,5,0);
  renderer.render(scene,camera);
}
animate();

// ====== YEAR & TRANSITION DEMO ======

const yearEl = document.getElementById("year");
const countdownEl = document.getElementById("countdown");

let demo = true;
let t = 0;

function update(){
  if(!demo) return;

  t += 0.02;

  if(t >= 1){
    demo = false;
    yearEl.innerHTML = "202<span id='last'>6</span>";
    document.getElementById("music").play();
    fireworks();
    return;
  }

  yearEl.innerHTML = "202<span id='last'>5</span>";

  const last = document.getElementById("last");
  gsap.fromTo(last,
    { y: 100, opacity: 0 },
    { y: 0, opacity: 1, duration: 0.5 }
  );
}
setInterval(update, 60);

function fireworks(){
  for(let i=0;i<30;i++){
    const fw = document.createElement("div");
    fw.className = "fw";
    fw.style.left = Math.random()*innerWidth+"px";
    fw.style.top = Math.random()*innerHeight/2+"px";
    fw.style.background = `hsl(${Math.random()*360},100%,60%)`;
    document.body.appendChild(fw);

    gsap.fromTo(fw,
      { scale: 0, opacity: 1 },
      { scale: 5, opacity: 0, duration: 1, onComplete:()=>fw.remove() }
    );
  }
}

