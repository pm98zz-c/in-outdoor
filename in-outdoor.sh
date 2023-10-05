#!/bin/sh

# in-outdoor.sh
# Copyright (C) 2022  Pascal Morin

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

### Gnome 3+/Legacy GTK
GTK_IN_THEME="Adwaita-dark"
GTK_OUT_THEME="Adwaita"
### Gnome 42+
SHELL_IN_THEME="prefer-dark"
SHELL_OUT_THEME="prefer-light"
### Night Light @see https://help.gnome.org/users/gnome-help/stable/display-night-light.html
NIGHT_LIGHT_IN="true"
NIGHT_LIGHT_OUT="false"
### VSCode @see https://code.visualstudio.com/
VS_CODE_IN_THEME="Default Dark Modern"
VS_CODE_OUT_THEME="Default Light Modern"
### Screen brightness @see https://github.com/Hummer12007/brightnessctl
BRIGHTNESS_IN="85%"
BRIGHTNESS_OUT="100%"

### Load configuration.
if [ -z "$XDG_CONFIG_HOME" ]; then
  XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -f "$XDG_CONFIG_HOME/in-out.ini" ]; then
  # shellcheck source=/dev/null
  . "$XDG_CONFIG_HOME/in-out.ini"
fi

# Default to "in" theme.
GTK_SWITCH_THEME="$GTK_IN_THEME"
SHELL_SWITCH_THEME="$SHELL_IN_THEME"
BRIGHTNESS_SWITCH="$BRIGHTNESS_IN"
SWITCH_IS="in"
NIGHT_LIGHT_SWITCH="$NIGHT_LIGHT_IN"

switch_out(){
  GTK_SWITCH_THEME="$GTK_OUT_THEME"
  SHELL_SWITCH_THEME="$SHELL_OUT_THEME"
  BRIGHTNESS_SWITCH="$BRIGHTNESS_OUT"
  NIGHT_LIGHT_SWITCH="$NIGHT_LIGHT_OUT"
  SWITCH_IS="out"
}

# First try to use the newer dark mode.
CURRENT_THEME=$(gsettings get org.gnome.desktop.interface color-scheme)
COMPARE_THEME="$SHELL_IN_THEME"
# Not yet on gnome 42, fallback to legacy theme.
if [ -z "$CURRENT_THEME" ]; then
  CURRENT_THEME="$(gsettings get org.gnome.desktop.interface gtk-theme)"
  COMPARE_THEME="$GTK_IN_THEME"
fi
# See if we need to trigger switch. Themes are stored within single quotes.
CURRENT_THEME=$(echo "$CURRENT_THEME" | sed "s/'//g")
if [ "$CURRENT_THEME" = "$COMPARE_THEME" ]; then
  switch_out
fi

################################# Actual processing.

### Gnome-shell
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_SWITCH_THEME"
gsettings set org.gnome.desktop.wm.preferences theme "$GTK_SWITCH_THEME"
gsettings set org.gnome.desktop.interface color-scheme "$SHELL_SWITCH_THEME"
# Night Light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled "$NIGHT_LIGHT_SWITCH"
### Visual Studio Code.
VS_CODE_SETTINGS="$XDG_CONFIG_HOME/Code/User/settings.json"
if [ -f "$VS_CODE_SETTINGS" ]; then
    REPLACE="s/$VS_CODE_OUT_THEME/$VS_CODE_IN_THEME/g"
    if [ "$SWITCH_IS" = "out" ]; then
      REPLACE="s/$VS_CODE_IN_THEME/$VS_CODE_OUT_THEME/g"
    fi
  sed -e "$REPLACE" "$VS_CODE_SETTINGS" > /tmp/vscsettings.tmp && mv /tmp/vscsettings.tmp "$VS_CODE_SETTINGS"
fi

### Screen brightness
if command -v brightnessctl > /dev/null ; then
  brightnessctl set "$BRIGHTNESS_SWITCH" > /dev/null
fi