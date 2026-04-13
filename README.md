### Requirements

- git
- stow

### Adding dotfile with stow

1. Remove existed configs or backup it
2. Use "stow config_folder_name" command to create symlinks

### zshrc

If you need additional configs for external tools
put configs files in $HOME/zshrc-external folder

### KDE / Plasma

KDE stores its config in `~/.config/`. All files are symlinked via `stow kde`.

#### `~/.config/`

| File | Description |
|---|---|
| `kdeglobals` | Global KDE settings: color scheme, fonts, icon theme, widget style |
| `kwinrc` | KWin window manager: window behavior, effects, virtual desktops, tiling, focus policy |
| `kglobalshortcutsrc` | All global keyboard shortcuts (KWin, Plasma, app launchers, media keys) |
| `plasmarc` | Plasma shell appearance: theme, desktop effects toggle, wallpaper plugin |
| `plasma-org.kde.plasma.desktop-appletsrc` | Desktop layout: panel position/size, widgets and their configuration |
| `plasmashellrc` | Plasma shell runtime settings: panel visibility, hiding behavior |
| `kcminputrc` | Mouse and touchpad settings: speed, acceleration, scroll direction, tap-to-click |
| `kscreenlockerrc` | Lock screen settings: timeout, appearance, require password delay |
| `dolphinrc` | Dolphin file manager: view mode, sidebar, toolbar, sorting preferences |
| `kwinoutputconfig.json` | Monitor layout: resolution, refresh rate, scale, position of each display |
| `plasma-localerc` | Locale and language settings: date/time format, number format, currency |

#### `~/.config/kdedefaults/`

Overrides shipped by the active global theme. These take lower priority than the user config above but define the baseline look when a theme is applied.

| File | Description |
|---|---|
| `kdeglobals` | Theme-provided defaults for colors, fonts, and widget style |
| `kwinrc` | Theme-provided KWin defaults (effects, decoration) |
| `plasmarc` | Theme-provided Plasma appearance defaults |
| `kcminputrc` | Theme-provided input defaults |
| `ksplashrc` | Splash screen (boot/login animation) selection |
| `package` | Identifies which global theme package set these defaults |

### Help

https://www.youtube.com/watch?v=NoFiYOqnC4o
