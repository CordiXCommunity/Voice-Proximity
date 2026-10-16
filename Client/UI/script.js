// Voice Proximity | Creator: Max Cordiau - Cordix
var voice = document.getElementById("voice");
var bars = document.getElementById("bars");
var label = document.getElementById("label");
var items = bars.querySelectorAll(".bar");

var debug = false;
var showLabel = true;
var labels = [];
var quietUntil = 0;
var labelTimer = null;

// language-neutral debug logs (no translated text here)
function log(message) {
  if (debug) console.log("[voice-proximity][DEBUG][UI] " + message);
}

Events.Subscribe("Init", function (hud) {
  if (!hud) return;
  debug = !!hud.debug;
  showLabel = hud.showLabel !== false;
  labels = hud.labels || [];
  voice.style.right = (hud.right || 22) + "px";
  voice.style.bottom = (hud.bottom || 22) + "px";
  if (hud.accent) document.documentElement.style.setProperty("--accent", hud.accent);
  if (hud.idle) document.documentElement.style.setProperty("--idle", hud.idle);
  quietUntil = Date.now() + 2500;
  log("init");
});

Events.Subscribe("SetMode", function (index) {
  log("mode=" + index);
  for (var i = 0; i < items.length; i++) {
    items[i].classList.toggle("on", i < index);
  }
  bars.classList.remove("pulse");
  void bars.offsetWidth;
  bars.classList.add("pulse");

  if (showLabel && labels[index - 1] && Date.now() > quietUntil) {
    label.textContent = labels[index - 1];
    label.classList.add("show");
    clearTimeout(labelTimer);
    labelTimer = setTimeout(function () { label.classList.remove("show"); }, 1500);
  }
});

Events.Subscribe("SetTalking", function (talking) {
  log("talking=" + !!talking);
  voice.classList.toggle("talking", !!talking);
});
