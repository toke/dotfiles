#!/usr/bin/env sh
# POSIX shell compliant
#
# THIS IS A SKELETON FILE FOR POSIX SHELL SCRIPTS
#
#

set -e

command="/usr/bin/pymodoro-i3blocks --daemon"
#interval=persist
#format=json

## Setup
__file=${0##/*/}

arg="${1:-}"
[ $# -gt 0 ] && shift

## defaults
: ${debug:="0"}

$command

# vim: set ft=sh :

