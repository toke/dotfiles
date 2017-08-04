#
# Perform basic multimedia actions
#


readonly MIXER_BIN="/usr/bin/pamixer"
readonly MM_BIN="/usr/bin/xdotool"


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

alias mm_pause="${MM_BIN} key XF86AudioPlay"
alias mm_prev="${MM_BIN} key XF86AudioPrev"
alias mm_next="${MM_BIN} key XF86AudioNext"
alias mm_down="${MM_BIN} key XF86AudioLowerVolume"
alias mm_up="${MM_BIN} key XF86AudioRaiseVolume"
alias mm_mute="${MM_BIN} key XF86AudioMute"

