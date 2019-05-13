#!/bin/sh
# Profile file. Runs on login.

# Adds `~/.scripts` and all subdirectories to $PATH
[ -e $HOME/.scripts ] && export PATH="$PATH:$(du "$HOME/.scripts/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
[ -e $HOME/bin ] && export PATH="$PATH:$HOME/bin"
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export BROWER="/usr/bin/firefox"
export TERMINAL="termite"
export READER="zathura"
export FILE="vifm"
#export SUDO_ASKPASS="$HOME/.scripts/tools/dmenupass"
#export NOTMUCH_CONFIG="$HOME/.config/notmuch-config"
#export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"; a="${a%_}"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"; a="${a%_}"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"; a="${a%_}"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"; a="${a%_}"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"; a="${a%_}"

export XKB_DEFAULT_LAYOUT=de,us
export XKB_DEFAULT_VARIANT=nodeadkeys
export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle,

export GPG_TYT=$(tty)

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

# Start graphical server if i3 not already running.
[ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && exec bin/sway-bin



# Switch escape and caps if tty:
#sudo -n loadkeys ~/.scripts/ttymaps.kmap 2>/dev/null
[ -e "/etc/profile.d/plan9.sh" ] && source "/etc/profile.d/plan9.sh"

