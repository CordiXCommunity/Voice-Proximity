# Voice Proximity

**Créateur : Max Cordiau - Cordix**

VOIP de proximité pour Nanos World, dans le style des serveurs GTA RP : trois modes (chuchoter, normal, crier), une touche pour changer, un petit indicateur discret en bas à droite et un cercle au sol qui montre la portée de ta voix.

## Fonctionnalités

- 3 portées configurables : chuchoter (3 m), normal (10 m), crier (25 m).
- Changement de mode avec une touche (F5 par défaut), sans menu.
- Cercle au sol à chaque changement de mode : il grandit depuis tes pieds jusqu'à la portée réelle, te suit, puis disparaît. Une couleur par mode. Si tu maintiens la touche, le cercle reste affiché tant que tu l'appuies.
- HUD compact : 3 barres = mode choisi (toujours visible), micro = activité (s'allume quand tu parles). Le nom du mode s'affiche 1,5 seconde au changement (désactivable).
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

Tout se règle dans `Shared/config.lua` :

| Option | Rôle |
|---|---|
| `language` | Langue de tous les textes : `"fr"` ou `"en"` |
| `debug` | `true` = messages de debug dans la console ; `false` = silencieux |
| `key` | Touche de changement de mode (`"F5"`, `"V"`, ...) |
| `defaultMode` | Mode au spawn (1 = chuchoter, 2 = normal, 3 = crier) |
| `modes[].meters` | Portée de chaque mode, en mètres |
| `modes[].color` | Couleur du cercle `{ r, g, b }`, valeurs entre 0 et 1 |
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
| `hud.right` / `hud.bottom` | Position du HUD, en pixels |
| `hud.accent` / `hud.idle` | Couleurs du micro actif / inactif |
| `hud.showLabel` | `true` = nom du mode affiché brièvement au changement |

## Cercle au sol

À chaque changement de mode, un cercle apparaît à tes pieds et s'agrandit jusqu'au rayon exact de la portée choisie (3, 10 ou 25 m par défaut). Seul toi le vois. Il n'apparaît pas à la connexion, seulement lors d'un vrai changement.

- **Appui rapide** : le cercle reste `circle.duration` secondes, puis disparaît.
- **Touche maintenue** : le cercle reste affiché tant que tu maintiens la touche, puis disparaît `circle.releaseDelay` seconde(s) après le relâchement. Le maintien ne raccourcit jamais l'affichage, il ne fait que le prolonger.
- **Sécurité** : si le relâchement n'est jamais détecté (par exemple si le jeu perd le focus), le cercle est retiré après `circle.maxHold` secondes.

Le cercle est tracé avec la classe `Debug` de Nanos World (`Debug.DrawLine`). Si le cercle flotte ou s'enfonce dans le sol, ajuste `circle.groundOffset`. S'il est trop fin, augmente `circle.thickness`.

## Langue

Change `language = "fr"` en `language = "en"` dans `Shared/config.lua`, puis `package reload voice-proximity`. Cela traduit les messages de la console, les erreurs de configuration, les commandes de debug et le nom du mode affiché dans le HUD.

Pour ajouter une langue (ex. espagnol), copie un bloc de `Shared/lang.lua`, renomme-le (`es = { ... }`), traduis les valeurs sans toucher aux clés, puis mets `language = "es"`. Une clé manquante retombe sur l'anglais. Si les accents s'affichent mal dans ta console, enregistre les fichiers en UTF-8.

## Mode debug

Mets `debug = true` dans `Shared/config.lua`, puis `package reload voice-proximity`.

- Messages `[DEBUG][SERVER]` et `[CLIENT]` à chaque étape : spawn, touche appuyée et relâchée, mode envoyé, mode reçu, micro actif/inactif, HUD prêt, cercle affiché.
- Auto-test de la configuration au démarrage : les erreurs s'affichent toujours, même avec `debug = false`.
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
        |-- style.css  (apparence)
        `-- script.js  (logique du HUD)
```

## Événements

| Événement | Sens | Rôle |
|---|---|---|
| `VoiceProximity:Cycle` | Client vers Serveur | Demande le mode suivant |
| `VoiceProximity:Request` | Client vers Serveur | Demande l'état actuel |
| `VoiceProximity:Mode` | Serveur vers Client | Envoie l'index du mode actif |

## Dépannage

- Pas de HUD : active le debug ; si « HUD prêt » n'apparaît pas, vérifie que `Client/UI/index.html`, `style.css` et `script.js` existent.
- Pas de cercle : vérifie `circle.enabled = true` ; avec le debug, « cercle affiché » doit apparaître à chaque changement de mode.
- Le cercle disparaît alors que tu maintiens la touche : vérifie `circle.holdToKeep = true` et que « touche maintenue » apparaît dans la console avec le debug.
- Portée 100 fois trop grande ou petite : mets `unitsPerMeter = 1`.
- La touche ne fait rien : change `key` ; avec le debug, « touche F5 appuyée » doit apparaître côté client.
- Erreur `SetVOIPLocalSetting` dans la console serveur : vérifie la version du serveur.

## Crédits et licence

Créé par **Max Cordiau - Cordix**. Libre d'utilisation et de modification sur ton serveur ; garde cette mention de crédit.

---

# Voice Proximity (English)

**Creator: Max Cordiau - Cordix**

Proximity VOIP for Nanos World, in the style of GTA RP servers: three voice modes (whisper, normal, shout), one key to switch between them, a small discreet indicator in the bottom-right corner and a ground circle showing the range of your voice.

## Features

- 3 configurable ranges: whisper (3 m), normal (10 m), shout (25 m).
- Mode switching with a single key (F5 by default), no menu.
- Ground circle on every mode change: it grows from your feet to the real range, follows you, then disappears. One color per mode. If you hold the key, the circle stays visible as long as you press it.
- Compact HUD: 3 bars = selected mode (always visible), microphone = activity (lights up when you talk). The mode name shows for 1.5 seconds when you switch (can be disabled).
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

Everything is set in `Shared/config.lua`:

| Option | Purpose |
|---|---|
| `language` | Language of all texts: `"fr"` or `"en"` |
| `debug` | `true` = debug messages in the console; `false` = silent |
| `key` | Key used to switch mode (`"F5"`, `"V"`, ...) |
| `defaultMode` | Mode on spawn (1 = whisper, 2 = normal, 3 = shout) |
| `modes[].meters` | Range of each mode, in meters |
| `modes[].color` | Circle color `{ r, g, b }`, values between 0 and 1 |
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
| `hud.right` / `hud.bottom` | HUD position, in pixels |
| `hud.accent` / `hud.idle` | Colors of the active / inactive microphone |
| `hud.showLabel` | `true` = mode name briefly shown when you switch |

## Ground circle

Each time you change mode, a circle appears at your feet and grows to the exact radius of the selected range (3, 10 or 25 m by default). Only you can see it. It is not shown when you join, only on a real mode change.

- **Quick tap**: the circle stays for `circle.duration` seconds, then disappears.
- **Key held**: the circle stays visible as long as you hold the key, then disappears `circle.releaseDelay` second(s) after you release it. Holding never shortens the display, it only extends it.
- **Safety**: if the key release is never detected (for example if the game loses focus), the circle is removed after `circle.maxHold` seconds.

The circle is drawn with Nanos World's `Debug` class (`Debug.DrawLine`). If the circle floats or sinks into the ground, adjust `circle.groundOffset`. If it is too thin, raise `circle.thickness`.

## Language

Change `language = "en"` to `language = "fr"` (or the opposite) in `Shared/config.lua`, then run `package reload voice-proximity`. This translates console messages, configuration errors, debug commands and the mode name shown in the HUD.

To add a language (e.g. Spanish), copy a block from `Shared/lang.lua`, rename it (`es = { ... }`), translate the values without touching the keys, then set `language = "es"`. A missing key falls back to English. If accents look wrong in your console, save the files as UTF-8.

## Debug mode

Set `debug = true` in `Shared/config.lua`, then run `package reload voice-proximity`.

- `[DEBUG][SERVER]` and `[CLIENT]` messages at every step: spawn, key pressed and released, mode sent, mode received, microphone active/inactive, HUD ready, circle shown.
- Configuration self-test at startup: errors are always shown, even with `debug = false`.
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
        |-- style.css  (appearance)
        `-- script.js  (HUD logic)
```

## Events

| Event | Direction | Purpose |
|---|---|---|
| `VoiceProximity:Cycle` | Client to Server | Requests the next mode |
| `VoiceProximity:Request` | Client to Server | Requests the current state |
| `VoiceProximity:Mode` | Server to Client | Sends the index of the active mode |

## Troubleshooting

- No HUD: enable debug; if "HUD ready" never appears, make sure `Client/UI/index.html`, `style.css` and `script.js` exist.
- No circle: check `circle.enabled = true`; with debug on, "circle shown" should appear at every mode change.
- The circle disappears while you hold the key: check `circle.holdToKeep = true` and that "key held" appears in the console with debug on.
- Range 100 times too large or too small: set `unitsPerMeter = 1`.
- The key does nothing: change `key`; with debug on, "key F5 pressed" should appear on the client.
- `SetVOIPLocalSetting` error in the server console: check your server version.

## Credits and License

Created by **Max Cordiau - Cordix**. Free to use and modify on your server; please keep this credit notice.
