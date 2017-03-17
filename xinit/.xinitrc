#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
export XKB_DEFAULT_LAYOUT=de,us
export XKB_DEFAULT_VARIANT=,nodeadkeys
export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle

#syndaemon -i 1 -t -K -d
xset -dpms

/usr/bin/env xrdb -load ~/.Xresources
/usr/bin/env gpg-agent --daemon

# exec xterm
# exec gnome-session
# exec startkde
# exec startxfce4
#/...or the Window Manager of your choice

exec i3
