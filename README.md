# Voice Proximity

**Créateur : Max Cordiau - Cordix**

VOIP de proximité pour Nanos World, dans le style des serveurs GTA RP : trois modes (chuchoter, normal, crier), une touche pour changer, et un petit indicateur discret en bas à droite.

## Fonctionnalités

- 3 portées configurables : chuchoter (3 m), normal (10 m), crier (25 m).
- Changement de mode avec une touche (F5 par défaut), sans menu.
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
| `unitsPerMeter` | Conversion mètres vers unités du jeu (100 par défaut) |
| `hud.right` / `hud.bottom` | Position du HUD, en pixels |
| `hud.accent` / `hud.idle` | Couleurs du micro actif / inactif |
| `hud.showLabel` | `true` = nom du mode affiché brièvement au changement |

## Langue

Change `language = "fr"` en `language = "en"` dans `Shared/config.lua`, puis `package reload voice-proximity`. Cela traduit :

- les messages de la console (serveur et client) ;
- les erreurs de configuration ;
- les commandes de debug ;
- le nom du mode affiché dans le HUD.

Pour ajouter une langue (ex. espagnol), copie un bloc de `Shared/lang.lua`, renomme-le (`es = { ... }`), traduis les valeurs sans toucher aux clés, puis mets `language = "es"`. Une clé manquante retombe sur l'anglais. Si les accents s'affichent mal dans ta console, enregistre les fichiers en UTF-8.

## Mode debug

Mets `debug = true` dans `Shared/config.lua`, puis `package reload voice-proximity`.

- Messages `[voice-proximity][DEBUG][SERVER]` et `[CLIENT]` à chaque étape : spawn, touche appuyée, mode envoyé, mode reçu, micro actif/inactif, HUD prêt.
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
- Portée 100 fois trop grande ou petite : mets `unitsPerMeter = 1`.
- La touche ne fait rien : change `key` ; avec le debug, « touche F5 appuyée » doit apparaître côté client.
- Erreur `SetVOIPLocalSetting` dans la console serveur : vérifie la version du serveur.

## Crédits et licence

Créé par **Max Cordiau - Cordix**. Libre d'utilisation et de modification sur ton serveur ; garde cette mention de crédit.

---

# Voice Proximity (English)

**Creator: Max Cordiau - Cordix**

Proximity VOIP for Nanos World, in the style of GTA RP servers: three voice modes (whisper, normal, shout), one key to switch between them, and a small discreet indicator in the bottom-right corner.

## Features

- 3 configurable ranges: whisper (3 m), normal (10 m), shout (25 m).
- Mode switching with a single key (F5 by default), no menu.
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
| `unitsPerMeter` | Conversion from meters to game units (100 by default) |
| `hud.right` / `hud.bottom` | HUD position, in pixels |
| `hud.accent` / `hud.idle` | Colors of the active / inactive microphone |
| `hud.showLabel` | `true` = mode name briefly shown when you switch |

## Language

Change `language = "en"` to `language = "fr"` (or the opposite) in `Shared/config.lua`, then run `package reload voice-proximity`. This translates:

- console messages (server and client);
- configuration errors;
- debug commands;
- the mode name shown in the HUD.

To add a language (e.g. Spanish), copy a block from `Shared/lang.lua`, rename it (`es = { ... }`), translate the values without touching the keys, then set `language = "es"`. A missing key falls back to English. If accents look wrong in your console, save the files as UTF-8.

## Debug mode

Set `debug = true` in `Shared/config.lua`, then run `package reload voice-proximity`.

- `[voice-proximity][DEBUG][SERVER]` and `[CLIENT]` messages at every step: spawn, key pressed, mode sent, mode received, microphone active/inactive, HUD ready.
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
- Range 100 times too large or too small: set `unitsPerMeter = 1`.
- The key does nothing: change `key`; with debug on, "key F5 pressed" should appear on the client.
- `SetVOIPLocalSetting` error in the server console: check your server version.

## Credits and License

Created by **Max Cordiau - Cordix**. Free to use and modify on your server; please keep this credit notice.
