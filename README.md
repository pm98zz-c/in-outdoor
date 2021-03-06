# in-outdoor
A tiny shell script to switch the Gnome desktop environment from dark to light theme. I'm using it when moving my laptop from indoor to outdoor, but can be used for night/day times too.

It supports both standard GTK3 themes and the newer Gnome 42 global "dark mode", ensuring all application are toggled regardless of which one they use.

By defaul, it also turns Night Light off for the "out" (light) mode and back on for "in" (dark) mode (see [configuration](README.md#configuration) to change that)

Additionally, it can also toggle:
- VS Code themes
- Screen brightness

![in-out.gif](in-out.gif)

## Usage
Simply call ./in-outdoor.sh to toggle between the two configurations. You can of course add an alias in your .bashrc/.zshrc (eg `alias in-out="/bin/sh /home/me/path/to/in-outdoor/in-outdoor.sh"
`) or assign it a keyboard shortcut.

## Dependencies
The only hard dependency is Gnome's gsettings utility. To be able to set the screen brightness, you'll need https://github.com/Hummer12007/brightnessctl (available in most distros).

## Configuration
You can customize a few things by creating a ~/.config/in-out.ini file.
The default values for the available options are:

```
# file ~/.config/in-out.ini

### Gnome 3+/Legacy GTK
# To see which themes are available, use gnome-tweak-tool. You can get the currently active theme with `gsettings get org.gnome.desktop.interface gtk-theme`.
GTK_IN_THEME="Adwaita-dark" # That would be "Yaru-dark" on Ubuntu
GTK_OUT_THEME="Adwaita" # Yaru on Ubuntu

### Gnome 42+
SHELL_IN_THEME="prefer-dark"
SHELL_OUT_THEME="prefer-light"

### Night Light @see https://help.gnome.org/users/gnome-help/stable/display-night-light.html
NIGHT_LIGHT_IN="true"
NIGHT_LIGHT_OUT="false"

### VSCode @see https://code.visualstudio.com/
VS_CODE_IN_THEME="Default Dark+"
VS_CODE_OUT_THEME="Default Light+"

### Screen brightness @see https://github.com/Hummer12007/brightnessctl
BRIGHTNESS_IN="85%"
BRIGHTNESS_OUT="100%"

```

## Known issues / limitations

- This was created for my personal use, and tested only on Debian, it might not fit your use case or work on your setup. 
- Keep in mind that the Gnome 42 dark mode is fairly new, and the transition might be a bit rocky before all apps are migrated.
- Some non-native apps (Electron, Flakpak, etc) won't be toggled unless they are ported to the new Gnome 42 API.
