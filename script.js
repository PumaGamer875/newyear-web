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
scene.add(new THREE.AmbientLight(0x4040ff, 1));
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
for(let i=0;i<300;i++){
  const h = Math.random()*12+2;
  const b = new THREE.Mesh(
    new THREE.BoxGeometry(1.5, h, 1.5),
    new THREE.MeshStandardMaterial({ color:0x0b1b3a })
  );
  b.position.set((Math.random()-0.5)*80, h/2, (Math.random()-0.5)*80);
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
  if(demo){
    t += 0.01;
    if(t>1){
      demo=false;
      yearEl.textContent = "2026";
      gsap.fromTo("#year",{scale:0.3,opacity:0},{scale:1,opacity:1,duration:1});
    } else {
      countdownEl.textContent = "Demostración de transición...";
    }
  }
}
setInterval(update,50);
