#!/bin/sh
# Profile file. Runs on login.

# Adds `~/.scripts` and all subdirectories to $PATH
export PATH="$PATH:$(find $HOME/.local/bin/ -follow -type d -printf :%p )"
[ -e $HOME/bin ] && export PATH="$PATH:$HOME/bin"

export EDITOR="/usr/bin/nvim"
export FCEDITOR="$EDITOR"
export VISUAL="$EDITOR"
export BROWSER="/usr/bin/firefox"
export TERMINAL="/usr/bin/termite"
export READER="/usr/bin/zathura"
export FILE="/usr/bin/vifm"
#export SUDO_ASKPASS="$HOME/.scripts/tools/dmenupass"
export NOTMUCH_CONFIG="$HOME/.config/notmuch-config"
#export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export LESS=-r

export XDG_MUSIC_DIR=$HOME/Music

export GDK_BACKEND=wayland
#export CLUTTER_BACKEND=wayland

export GPG_TYT=$(tty)

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"
echo "$0" | grep "mksh$" >/dev/null && [ -f ~/.mkshrc ] && source "$HOME/.mkshrc"

# Switch escape and caps if tty:
#sudo -n loadkeys ~/.scripts/ttymaps.kmap 2>/dev/null
[ -e "/etc/profile.d/plan9.sh" ] && source "/etc/profile.d/plan9.sh"

[ -e $HOME/gocode ] && export GOPATH="$HOME/gocode"
[ -e $HOME/gocode/bin ] && PATH="$PATH:$HOME/gocode/bin"

# Set environment for pip + requests to find combined root CA certs
[ -e /etc/ssl/certs/ca-certificates.crt ] && export PIP_CERT="/etc/ssl/certs/ca-certificates.crt"
[ -e "$PIP_CERT" ] && export REQUESTS_CA_BUNDLE="$PIP_CERT"



## QUICKFIX-Remove Duplicate
PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')

# Start graphical server if i3 not already running.
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && exec bin/sway-bin


