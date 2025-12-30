const yearEl = document.getElementById("year");
const countdownEl = document.getElementById("countdown");
const fireworks = document.getElementById("fireworks");

let celebrated = false;

function updateClock() {
  const now = new Date();
  const target = new Date("2026-01-01T00:00:00");
  const diff = target - now;

  if (diff <= 0) {
    yearEl.textContent = "2026";
    countdownEl.textContent = "🎉 ¡Feliz Año Nuevo! 🎆";

    if (!celebrated) {
      celebrated = true;
      celebrate();
    }
    return;
  }

  const d = Math.floor(diff / 86400000);
  const h = Math.floor(diff / 3600000) % 24;
  const m = Math.floor(diff / 60000) % 60;
  const s = Math.floor(diff / 1000) % 60;

  countdownEl.textContent =
    `Faltan ${d}d ${h}h ${m}m ${s}s`;
}

setInterval(updateClock, 1000);
updateClock();

/* ===== TRANSICIÓN VISUAL ===== */

gsap.from("#year", {
  scale: 0.8,
  opacity: 0,
  duration: 2,
  ease: "power3.out"
});

/* ===== FUEGOS ARTIFICIALES ===== */

function celebrate() {
  gsap.to("#year", {
    color: "#ff4",
    textShadow: "0 0 40px #ff4",
    duration: 1,
    repeat: -1,
    yoyo: true
  });

  setInterval(spawnFirework, 200);
}

function spawnFirework() {
  const fw = document.createElement("div");
  fw.className = "firework";
  fw.style.left = Math.random() * innerWidth + "px";
  fw.style.top = innerHeight + "px";
  fw.style.background = `hsl(${Math.random()*360},100%,60%)`;

  fireworks.appendChild(fw);

  gsap.to(fw, {
    y: -innerHeight * Math.random(),
    opacity: 0,
    scale: 3,
    duration: 1.5,
    ease: "power2.out",
    onComplete: () => fw.remove()
  });
}
