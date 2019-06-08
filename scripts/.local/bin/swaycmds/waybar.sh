#!/usr/bin/env sh

export XDG_CURRENT_DESKTOP=Unity

# Terminate already running bar instances
killall -g -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch main
exec waybar 2>&1 | ts >> /tmp/waybar &
