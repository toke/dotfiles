#!/bin/sh
# Profile file. Runs on login.

# Adds `~/.scripts` and all subdirectories to $PATH
[ -e $HOME/.scripts ] && export PATH="$PATH:$(du "$HOME/.scripts/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
[ -e $HOME/bin ] && export PATH="$PATH:$HOME/bin"

export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export BROWER="/usr/bin/firefox"
export TERMINAL="/usr/bin/termite"
export READER="/usr/bin/zathura"
export FILE="/usr/bin/vifm"
#export SUDO_ASKPASS="$HOME/.scripts/tools/dmenupass"
#export NOTMUCH_CONFIG="$HOME/.config/notmuch-config"
#export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export LESS=-r

export XDG_MUSIC_DIR=$HOME/Music

export GDK_BACKEND=wayland
#export CLUTTER_BACKEND=wayland

export GPG_TYT=$(tty)

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

# Switch escape and caps if tty:
#sudo -n loadkeys ~/.scripts/ttymaps.kmap 2>/dev/null
[ -e "/etc/profile.d/plan9.sh" ] && source "/etc/profile.d/plan9.sh"

# Start graphical server if i3 not already running.
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && exec bin/sway-bin

