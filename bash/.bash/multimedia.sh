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

