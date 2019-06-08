#!/usr/bin/env sh
# POSIX shell compliant
#

set -e

command='/usr/bin/pymodoro -ah -pp  -bs '
#interval=persist
#format=json

## Setup
__file=${0##/*/}

arg="${1:-}"
[ $# -gt 0 ] && shift

## defaults
: "${debug:="0"}"

$command

# vim: set ft=sh :

