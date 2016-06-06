#
# Perform basic multimedia actions
#


readonly MIXER_BIN="/usr/bin/pamixer"


# Increase Volume
function mixer-dec {
    "${MIXER_BIN}" --decrease 5
}

# Decrease Volume
function mixer-inc {
    "${MIXER_BIN}" --increase 5
}

# Toggles Mute/Unmute
function mixer-mute {
    "${MIXER_BIN}" -t
}

alias mm_pause="xdotool key XF86AudioPlay"
alias mm_prev="xdotool key XF86AudioPrev"
alias mm_next="xdotool key XF86AudioNext"
alias mm_up="xdotool key XF86AudioLowerVolume"
alias mm_down="xdotool key XF86AudioRaiseVolume"
alias mm_mute="xdotool key XF86AudioMute"

