#!/usr/bin/env sh
# POSIX shell compliant
#

set -e


## Setup
__file="${0##/*/}"

arg="${1:-}"
[ $# -gt 0 ] && shift

## defaults
: "${debug:="0"}"

<++>

# vim: set ft=sh :
