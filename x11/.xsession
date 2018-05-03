#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
export XKB_DEFAULT_LAYOUT=de,us
export XKB_DEFAULT_VARIANT=nodeadkeys
export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle

# CAPS->CTRL
setxkbmap -option ctrl:nocaps

/etc/X11/xinit/xinitrc.d/50-systemd-user.sh

#syndaemon -i 1 -t -K -d
xset -dpms

/usr/bin/xrdb "$HOME/.Xresources"

#/usr/lib/plan9/bin/plumber

#/usr/bin/env xrdb -load ~/.Xresources
/usr/bin/env gpg-agent --daemon --enable-ssh-support

xset s 300
/usr/bin/env light-locker --lock-on-suspend --lock-after-screensaver 20 &


