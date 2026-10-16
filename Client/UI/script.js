// Voice Proximity | Creator: Max Cordiau - Cordix
var voice = document.getElementById("voice");
var bars = document.getElementById("bars");
var notif = document.getElementById("notif");
var notifText = document.getElementById("notif-text");
var items = bars.querySelectorAll(".bar");
var root = document.documentElement;

var debug = false;
var hud = {};
var notification = { enabled: true, duration: 2 };
var texts = [];
var colors = [];
var notifTimer = null;

// language-neutral debug logs (no translated text here)
function log(message) {
  if (debug) console.log("[voice-proximity][DEBUG][UI] " + message);
}

function setVar(name, value) {
  if (value) root.style.setProperty(name, value);
}

// Applies the HUD settings coming from Shared/config.lua
function applyHud() {
  setVar("--bg", hud.background);
  setVar("--border", hud.border);
  setVar("--text", hud.textColor);
  setVar("--mic-idle", hud.micIdle);
  setVar("--mic-talk", hud.micTalking);
  setVar("--neon", hud.neon);
  setVar("--bar-on", hud.barsOn);
  setVar("--bar-off", hud.barsOff);
  setVar("--dot", hud.neon);
  setVar("--neon-size", (hud.neonSize === undefined ? 7 : hud.neonSize) + "px");

  // position: "bottom-right", "bottom-left", "top-right", "top-left"
  var parts = (hud.position || "bottom-right").split("-");
  var vertical = parts[0] === "top" ? "top" : "bottom";
  var horizontal = parts[1] === "left" ? "left" : "right";
  voice.style.top = voice.style.bottom = voice.style.left = voice.style.right = "auto";
  voice.style[vertical] = (hud.marginY === undefined ? 22 : hud.marginY) + "px";
  voice.style[horizontal] = (hud.marginX === undefined ? 22 : hud.marginX) + "px";
  voice.classList.toggle("top", vertical === "top");
  voice.classList.toggle("right", horizontal === "right");
  voice.classList.toggle("left", horizontal === "left");

  voice.classList.toggle("neon-pulse", hud.neonPulse !== false);
}

// When hud.followModeColor is true, the HUD takes the color of the current mode
function applyModeColor(index) {
  var color = colors[index - 1];
  if (!hud.followModeColor || !color) return;
  setVar("--mic-talk", color);
  setVar("--neon", color);
  setVar("--bar-on", color);
  setVar("--dot", color);
}

function showNotification(index) {
  if (!notification.enabled || !texts[index - 1]) return;
  notifText.textContent = texts[index - 1];
  // the dot always uses the color of the mode that was just selected
  if (colors[index - 1]) setVar("--dot", colors[index - 1]);
  notif.classList.add("show");
  clearTimeout(notifTimer);
  notifTimer = setTimeout(function () { notif.classList.remove("show"); },
    (notification.duration || 2) * 1000);
}

Events.Subscribe("Init", function (config) {
  if (!config) return;
  debug = !!config.debug;
  hud = config.hud || {};
  notification = config.notification || notification;
  texts = config.texts || [];
  colors = config.colors || [];
  applyHud();
  log("init");
});

Events.Subscribe("SetMode", function (index, announce) {
  log("mode=" + index + " announce=" + !!announce);
  for (var i = 0; i < items.length; i++) {
    items[i].classList.toggle("on", i < index);
  }
  applyModeColor(index);

  bars.classList.remove("pulse");
  void bars.offsetWidth;
  bars.classList.add("pulse");

  if (announce) showNotification(index);
});

Events.Subscribe("SetTalking", function (talking) {
  log("talking=" + !!talking);
  voice.classList.toggle("talking", !!talking);
});
