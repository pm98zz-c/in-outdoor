# in-outdoor
A tiny shell script to switch the Gnome desktop environment from dark/to light theme. I'm using for when using my laptop from indoor to outdoor, but can be used for night/day times too.

It supports both standard GTK3 themes and the newer Gnome 42 global "dark mode", ensuring all application are toggled regardless of which one they use.

Additionally, it can also toggle:
- VS Code themes
- Screen brightness

## Usage
Simply call ./in-outdoor.sh to toggle between the two configurations. You can of course add an alias in your .bashrc/.zshrc (eg `alias in-out="/bin/sh /home/me/path/to/in-out/in-outdoor.sh"
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
GTK_IN_THEME="Adwaita-dark"
GTK_OUT_THEME="HighContrast"

### Gnome 42+
SHELL_IN_THEME="prefer-dark"
SHELL_OUT_THEME="prefer-light"

### VSCode @see https://code.visualstudio.com/
VS_CODE_IN_THEME="Default Dark+"
VS_CODE_OUT_THEME="Default Light+"

### Screen brightness @see https://github.com/Hummer12007/brightnessctl
BRIGHTNESS_IN="85%"
BRIGHTNESS_OUT="100%"

```

## Known issues / limitations

This was created for my personal use, and tested only on Debian, it might not fit your use case or work on your setup.