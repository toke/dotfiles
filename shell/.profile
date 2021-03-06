#!/bin/sh
# Profile file. Runs on login.

appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}


# Adds `~/.scripts` and all subdirectories to $PATH
for path in ~/.local/bin/* ; do [ -d "$path" ] && appendpath $path ; done
unset path
[ -e $HOME/bin ] && appendpath "$HOME/bin"


[ -e $HOME/gocode ] && export GOPATH="$HOME/gocode"
[ -e $HOME/gocode/bin ] && appendpath "$HOME/gocode/bin"


# See also: ~/.pam_environment
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
export DMENU="bemenu"

export XDG_MUSIC_DIR=$HOME/Music

export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export QT_QPA_PLATFORM=wayland-egl

export GPG_TYT=$(tty)

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && . "$HOME/.bashrc"
echo "$0" | grep "mksh$" >/dev/null && [ -f ~/.mkshrc ] && . "$HOME/.mkshrc"

# Switch escape and caps if tty:
#sudo -n loadkeys ~/.scripts/ttymaps.kmap 2>/dev/null
# Set environment for pip + requests to find combined root CA certs

[ -e /etc/ssl/certs/ca-certificates.crt ] && export PIP_CERT="/etc/ssl/certs/ca-certificates.crt"
[ -e "$PIP_CERT" ] && export REQUESTS_CA_BUNDLE="$PIP_CERT"

unset appendpath

# Start graphical server if i3 not already running.
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && exec bin/sway-bin

