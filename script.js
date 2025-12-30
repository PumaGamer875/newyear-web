const yearEl = document.getElementById("year");
const countdownEl = document.getElementById("countdown");

function update() {
  const now = new Date();
  const target = new Date("2026-01-01T00:00:00");
  const diff = target - now;

  if (diff <= 0) {
    yearEl.textContent = "2026";
    countdownEl.textContent = "🎉 ¡Feliz Año Nuevo! 🎆";
    return;
  }

  const d = Math.floor(diff / 86400000);
  const h = Math.floor(diff / 3600000) % 24;
  const m = Math.floor(diff / 60000) % 60;
  const s = Math.floor(diff / 1000) % 60;

  countdownEl.textContent =
    `Faltan ${d} días ${h}h ${m}m ${s}s para 2026`;
}

setInterval(update, 1000);
update();
