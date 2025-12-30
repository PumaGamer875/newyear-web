const bigNum = document.getElementById("big-number");
const audio = document.getElementById("countdown-sound");

// Números descendentes de 10 a 0
let current = 10;

function playCountdown() {
  audio.currentTime = 0;
  audio.play();
}

function animateNumber(n) {
  bigNum.textContent = n;

  gsap.fromTo(bigNum, {
    y: 200,
    opacity: 0,
    scale: 0.5
  }, {
    y: 0,
    opacity: 1,
    scale: 1,
    duration: 0.7,
    ease: "back.out(1.7)"
  });
}

function startCountdown() {
  playCountdown();
  animateNumber(current);

  const interval = setInterval(() => {
    current--;
    if(current >= 0) {
      animateNumber(current);
      playCountdown();
    } else {
      clearInterval(interval);
      onFinish();
    }
  }, 1000);
}

function onFinish() {
  bigNum.textContent = "🎉 2026 🎆";
  gsap.to(bigNum, {
    color: "#ff4",
    textShadow: "0 0 60px #ff4, 0 0 120px #ff4",
    duration: 1.5,
    repeat: -1,
    yoyo: true
  });
}

// Iniciar la cuenta regresiva
startCountdown();
