# Voice Proximity

**Créateur : Max Cordiau - Cordix**

VOIP de proximité pour Nanos World, dans le style des serveurs GTA RP : trois modes (chuchoter, normal, crier), une touche pour changer, un petit HUD discret avec un micro néon, une notification à chaque changement et un cercle au sol qui montre la portée de ta voix.

## Fonctionnalités

- 3 portées configurables : chuchoter (3 m), normal (10 m), crier (25 m).
- Changement de mode avec une touche (F5 par défaut), sans menu.
- Notification discrète à chaque changement : « Voix : Chuchoter (3 m) », avec un point de la couleur du mode.
- Micro néon : l'icône s'allume en turquoise avec une lueur néon quand tu parles, et redevient sombre quand tu te tais.
- Cercle au sol à chaque changement de mode : il grandit depuis tes pieds jusqu'à la portée réelle, te suit, puis disparaît. Si tu maintiens la touche, il reste affiché.
- Toutes les couleurs et la position du HUD se règlent dans la config.
- Mode géré par le serveur : un joueur ne peut pas tricher côté client.
- Langue française ou anglaise pour tous les textes (console et en jeu).
- Mode debug : messages console, auto-test de la config et commandes de test sans joueur.

## Installation

1. Copie le dossier `voice-proximity` dans le dossier `Packages/` du serveur.
2. Ouvre `Config.toml` et ajoute le package dans la section `[game]` :

```toml
[game]
packages = [
    "voice-proximity",
]
```

3. Redémarre le serveur (ou `package load voice-proximity`).

Le nom du dossier est l'identifiant du package : minuscules, chiffres et `-` uniquement.

## Configuration

Tout se règle dans `Shared/config.lua`. Les couleurs s'écrivent `"#RRGGBB"` (ex. `"#2ee6c8"`) ; pour le HUD, tu peux aussi utiliser `rgba(10, 12, 14, 0.62)`.

| Option | Rôle |
|---|---|
| `language` | Langue de tous les textes : `"fr"` ou `"en"` |
| `debug` | `true` = messages de debug dans la console ; `false` = silencieux |
| `key` | Touche de changement de mode (`"F5"`, `"V"`, ...) |
| `defaultMode` | Mode au spawn (1 = chuchoter, 2 = normal, 3 = crier) |
| `modes[].meters` | Portée de chaque mode, en mètres |
| `modes[].color` | Couleur du mode : cercle, point de la notification (et HUD si `followModeColor`) |
| `unitsPerMeter` | Conversion mètres vers unités du jeu (100 par défaut) |
| `circle.enabled` | `true` = cercle au sol actif |
| `circle.duration` | Durée d'affichage après un appui rapide, en secondes |
| `circle.expandTime` | Durée de la croissance du cercle, en secondes |
| `circle.holdToKeep` | `true` = le cercle reste tant que la touche est maintenue |
| `circle.releaseDelay` | Durée de maintien après le relâchement, en secondes |
| `circle.maxHold` | Sécurité : durée maximale de maintien, en secondes |
| `circle.thickness` | Épaisseur du trait |
| `circle.groundOffset` | Distance entre le centre du personnage et le sol (90 par défaut) |
| `circle.segments` | Finesse du cercle (64 par défaut) |
| `notification.enabled` | `true` = notification à chaque changement de mode |
| `notification.duration` | Durée d'affichage de la notification, en secondes |
| `notification.showRange` | `true` = ajoute la portée en mètres |
| `hud.position` | `"bottom-right"`, `"bottom-left"`, `"top-right"` ou `"top-left"` |
| `hud.marginX` / `hud.marginY` | Distance au bord de l'écran, en pixels |
| `hud.background` / `hud.border` | Fond et bordure du HUD |
| `hud.textColor` | Couleur du texte de la notification |
| `hud.micIdle` | Couleur du micro quand tu te tais |
| `hud.micTalking` | Couleur du micro quand tu parles |
| `hud.neon` | Couleur de la lueur néon |
| `hud.neonSize` | Taille de la lueur en pixels (0 = aucune) |
| `hud.neonPulse` | `true` = la lueur pulse doucement quand tu parles |
| `hud.barsOn` / `hud.barsOff` | Couleur des barres actives / inactives |
| `hud.followModeColor` | `true` = micro, néon, barres et point suivent la couleur du mode |

## Notification, néon et couleurs

- **Notification** : à chaque changement de mode, une petite pastille apparaît au-dessus du HUD (en dessous si le HUD est en haut) pendant `notification.duration` secondes. Elle n'apparaît pas à la connexion.
- **Néon** : tant que tu parles, le micro prend la couleur `hud.micTalking` avec une lueur de la couleur `hud.neon`. Mets `hud.neonSize = 0` pour la supprimer ou `hud.neonPulse = false` pour une lueur fixe.
- **Couleurs** : change `hud.micTalking`, `hud.neon` et `hud.barsOn` pour un autre thème (par exemple `"#ff3df2"` pour un néon rose), ou mets `hud.followModeColor = true` pour que le HUD prenne la couleur de chaque mode.
- **Position** : `hud.position = "bottom-left"` place le HUD en bas à gauche.

## Cercle au sol

À chaque changement de mode, un cercle apparaît à tes pieds et s'agrandit jusqu'au rayon exact de la portée choisie. Seul toi le vois.

- **Appui rapide** : le cercle reste `circle.duration` secondes, puis disparaît.
- **Touche maintenue** : le cercle reste affiché tant que tu maintiens la touche, puis disparaît `circle.releaseDelay` seconde(s) après le relâchement.
- **Sécurité** : si le relâchement n'est jamais détecté, le cercle est retiré après `circle.maxHold` secondes.

Le cercle est tracé avec la classe `Debug` de Nanos World (`Debug.DrawLine`). S'il flotte ou s'enfonce dans le sol, ajuste `circle.groundOffset`. S'il est trop fin, augmente `circle.thickness`.

## Langue

Change `language = "fr"` en `language = "en"` dans `Shared/config.lua`, puis `package reload voice-proximity`. Cela traduit la console, les erreurs de configuration, les commandes de debug et la notification.

Pour ajouter une langue (ex. espagnol), copie un bloc de `Shared/lang.lua`, renomme-le (`es = { ... }`), traduis les valeurs sans toucher aux clés, puis mets `language = "es"`. Une clé manquante retombe sur l'anglais. Si les accents s'affichent mal dans ta console, enregistre les fichiers en UTF-8.

## Mode debug

Mets `debug = true` dans `Shared/config.lua`, puis `package reload voice-proximity`.

- Messages `[DEBUG][SERVER]` et `[CLIENT]` à chaque étape : spawn, touche appuyée et relâchée, mode envoyé, mode reçu, notification affichée, micro actif/inactif, HUD prêt, cercle affiché.
- Auto-test de la configuration au démarrage (couleurs, position du HUD, durées...) : les erreurs s'affichent toujours, même avec `debug = false`.
- Trois commandes dans la console du serveur (utilisables sans être en jeu) :

| Commande | Rôle |
|---|---|
| `voice_debug` | Rapport : config, vérification et mode de chaque joueur connecté |
| `voice_test` | Simule les appuis sur la touche (aucun joueur requis) |
| `voice_setmode <nom> <1-3>` | Force le mode d'un joueur connecté |

Remets `debug = false` en production.

## Structure

```
voice-proximity/
|-- Package.toml
|-- README.md
|-- CHANGELOG.md
|-- Shared/
|   |-- Index.lua      (point d'entrée partagé)
|   |-- config.lua     (configuration)
|   |-- lang.lua       (traductions FR / EN)
|   |-- colors.lua     (outils de couleurs)
|   `-- debug.lua      (logs et vérification de la config)
|-- Server/
|   |-- Index.lua      (point d'entrée serveur)
|   |-- voice.lua      (logique des modes et portées)
|   `-- commands.lua   (commandes de debug)
`-- Client/
    |-- Index.lua      (point d'entrée client)
    |-- circle.lua     (cercle au sol)
    |-- voice.lua      (touche, VOIP, communication avec le HUD)
    `-- UI/
        |-- index.html (structure du HUD)
        |-- style.css  (apparence, néon)
        `-- script.js  (logique du HUD et notification)
```

## Événements

| Événement | Sens | Rôle |
|---|---|---|
| `VoiceProximity:Cycle` | Client vers Serveur | Demande le mode suivant |
| `VoiceProximity:Request` | Client vers Serveur | Demande l'état actuel |
| `VoiceProximity:Mode` | Serveur vers Client | Envoie l'index du mode actif |

## Dépannage

- Pas de HUD : active le debug ; si « HUD prêt » n'apparaît pas, vérifie que `Client/UI/index.html`, `style.css` et `script.js` existent.
- Pas de notification : vérifie `notification.enabled = true` ; avec le debug, « notification affichée » doit apparaître à chaque changement.
- Pas de néon : vérifie `hud.neonSize > 0` ; avec le debug, « micro : parle (néon actif) » doit apparaître quand tu parles.
- Couleur ignorée : les couleurs du mode doivent être au format `"#RRGGBB"` ; le démarrage affiche une erreur de configuration sinon.
- Pas de cercle : vérifie `circle.enabled = true` ; avec le debug, « cercle affiché » doit apparaître à chaque changement.
- Portée 100 fois trop grande ou petite : mets `unitsPerMeter = 1`.
- La touche ne fait rien : change `key` ; avec le debug, « touche F5 appuyée » doit apparaître côté client.
- Erreur `SetVOIPLocalSetting` dans la console serveur : vérifie la version du serveur.

## Crédits et licence

Créé par **Max Cordiau - Cordix**. Libre d'utilisation et de modification sur ton serveur ; garde cette mention de crédit.

---

# Voice Proximity (English)

**Creator: Max Cordiau - Cordix**

Proximity VOIP for Nanos World, in the style of GTA RP servers: three voice modes (whisper, normal, shout), one key to switch between them, a small discreet HUD with a neon microphone, a notification at every change and a ground circle showing the range of your voice.

## Features

- 3 configurable ranges: whisper (3 m), normal (10 m), shout (25 m).
- Mode switching with a single key (F5 by default), no menu.
- Discreet notification at every change: "Voice: Whisper (3 m)", with a dot in the color of the mode.
- Neon microphone: the icon lights up in turquoise with a neon glow while you talk, and goes dark again when you are silent.
- Ground circle on every mode change: it grows from your feet to the real range, follows you, then disappears. If you hold the key, it stays visible.
- All the colors and the HUD position are set in the config.
- Mode managed by the server: a player cannot cheat from the client side.
- French or English for every text (console and in game).
- Debug mode: console messages, config self-test and test commands that need no player.

## Installation

1. Copy the `voice-proximity` folder into the server's `Packages/` folder.
2. Open `Config.toml` and add the package in the `[game]` section:

```toml
[game]
packages = [
    "voice-proximity",
]
```

3. Restart the server (or run `package load voice-proximity`).

The folder name is the package identifier: lowercase letters, digits and `-` only.

## Configuration

Everything is set in `Shared/config.lua`. Colors are written `"#RRGGBB"` (e.g. `"#2ee6c8"`); for the HUD you can also use `rgba(10, 12, 14, 0.62)`.

| Option | Purpose |
|---|---|
| `language` | Language of all texts: `"fr"` or `"en"` |
| `debug` | `true` = debug messages in the console; `false` = silent |
| `key` | Key used to switch mode (`"F5"`, `"V"`, ...) |
| `defaultMode` | Mode on spawn (1 = whisper, 2 = normal, 3 = shout) |
| `modes[].meters` | Range of each mode, in meters |
| `modes[].color` | Color of the mode: circle, notification dot (and HUD if `followModeColor`) |
| `unitsPerMeter` | Conversion from meters to game units (100 by default) |
| `circle.enabled` | `true` = ground circle enabled |
| `circle.duration` | How long the circle stays after a quick tap, in seconds |
| `circle.expandTime` | How long the circle takes to grow, in seconds |
| `circle.holdToKeep` | `true` = the circle stays as long as the key is held |
| `circle.releaseDelay` | How long the circle stays after the key is released, in seconds |
| `circle.maxHold` | Safety: maximum hold time, in seconds |
| `circle.thickness` | Line thickness |
| `circle.groundOffset` | Distance between the character center and the ground (90 by default) |
| `circle.segments` | Smoothness of the circle (64 by default) |
| `notification.enabled` | `true` = notification at every mode change |
| `notification.duration` | How long the notification stays, in seconds |
| `notification.showRange` | `true` = adds the range in meters |
| `hud.position` | `"bottom-right"`, `"bottom-left"`, `"top-right"` or `"top-left"` |
| `hud.marginX` / `hud.marginY` | Distance from the screen edge, in pixels |
| `hud.background` / `hud.border` | HUD background and border |
| `hud.textColor` | Notification text color |
| `hud.micIdle` | Microphone color when you are silent |
| `hud.micTalking` | Microphone color when you talk |
| `hud.neon` | Color of the neon glow |
| `hud.neonSize` | Glow size in pixels (0 = none) |
| `hud.neonPulse` | `true` = the glow gently pulses while you talk |
| `hud.barsOn` / `hud.barsOff` | Active / inactive bars color |
| `hud.followModeColor` | `true` = microphone, neon, bars and dot follow the color of the mode |

## Notification, neon and colors

- **Notification**: at every mode change, a small pill appears above the HUD (below it if the HUD is at the top) for `notification.duration` seconds. It does not appear when you join.
- **Neon**: while you talk, the microphone takes the `hud.micTalking` color with a glow in the `hud.neon` color. Set `hud.neonSize = 0` to remove it, or `hud.neonPulse = false` for a steady glow.
- **Colors**: change `hud.micTalking`, `hud.neon` and `hud.barsOn` for another theme (for example `"#ff3df2"` for a pink neon), or set `hud.followModeColor = true` so the HUD takes the color of each mode.
- **Position**: `hud.position = "bottom-left"` puts the HUD in the bottom-left corner.

## Ground circle

Each time you change mode, a circle appears at your feet and grows to the exact radius of the selected range. Only you can see it.

- **Quick tap**: the circle stays for `circle.duration` seconds, then disappears.
- **Key held**: the circle stays visible as long as you hold the key, then disappears `circle.releaseDelay` second(s) after you release it.
- **Safety**: if the key release is never detected, the circle is removed after `circle.maxHold` seconds.

The circle is drawn with Nanos World's `Debug` class (`Debug.DrawLine`). If it floats or sinks into the ground, adjust `circle.groundOffset`. If it is too thin, raise `circle.thickness`.

## Language

Change `language = "en"` to `language = "fr"` (or the opposite) in `Shared/config.lua`, then run `package reload voice-proximity`. This translates the console, configuration errors, debug commands and the notification.

To add a language (e.g. Spanish), copy a block from `Shared/lang.lua`, rename it (`es = { ... }`), translate the values without touching the keys, then set `language = "es"`. A missing key falls back to English. If accents look wrong in your console, save the files as UTF-8.

## Debug mode

Set `debug = true` in `Shared/config.lua`, then run `package reload voice-proximity`.

- `[DEBUG][SERVER]` and `[CLIENT]` messages at every step: spawn, key pressed and released, mode sent, mode received, notification shown, microphone active/inactive, HUD ready, circle shown.
- Configuration self-test at startup (colors, HUD position, durations...): errors are always shown, even with `debug = false`.
- Three server console commands (usable without being in the game):

| Command | Purpose |
|---|---|
| `voice_debug` | Report: config, validation and the mode of each connected player |
| `voice_test` | Simulates key presses (no player required) |
| `voice_setmode <name> <1-3>` | Forces a connected player's mode |

Set `debug = false` in production.

## Structure

```
voice-proximity/
|-- Package.toml
|-- README.md
|-- CHANGELOG.md
|-- Shared/
|   |-- Index.lua      (shared entry point)
|   |-- config.lua     (configuration)
|   |-- lang.lua       (FR / EN translations)
|   |-- colors.lua     (color helpers)
|   `-- debug.lua      (logs and config validation)
|-- Server/
|   |-- Index.lua      (server entry point)
|   |-- voice.lua      (mode and range logic)
|   `-- commands.lua   (debug commands)
`-- Client/
    |-- Index.lua      (client entry point)
    |-- circle.lua     (ground circle)
    |-- voice.lua      (key, VOIP, communication with the HUD)
    `-- UI/
        |-- index.html (HUD structure)
        |-- style.css  (appearance, neon)
        `-- script.js  (HUD logic and notification)
```

## Events

| Event | Direction | Purpose |
|---|---|---|
| `VoiceProximity:Cycle` | Client to Server | Requests the next mode |
| `VoiceProximity:Request` | Client to Server | Requests the current state |
| `VoiceProximity:Mode` | Server to Client | Sends the index of the active mode |

## Troubleshooting

- No HUD: enable debug; if "HUD ready" never appears, make sure `Client/UI/index.html`, `style.css` and `script.js` exist.
- No notification: check `notification.enabled = true`; with debug on, "notification shown" should appear at every change.
- No neon: check `hud.neonSize > 0`; with debug on, "microphone: speaking (neon on)" should appear when you talk.
- Color ignored: mode colors must use the `"#RRGGBB"` format; startup shows a configuration error otherwise.
- No circle: check `circle.enabled = true`; with debug on, "circle shown" should appear at every change.
- Range 100 times too large or too small: set `unitsPerMeter = 1`.
- The key does nothing: change `key`; with debug on, "key F5 pressed" should appear on the client.
- `SetVOIPLocalSetting` error in the server console: check your server version.

## Credits and License

Created by **Max Cordiau - Cordix**. Free to use and modify on your server; please keep this credit notice.
