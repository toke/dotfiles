#!/usr/bin/env bash
# POSIX shell compliant
#


: "${TEST_HOSTS:=8.8.8.8 1.1.1.1 188.40.41.113}"



## Setup
__file="${0##/*/}"

arg="${1:-}"
[ $# -gt 0 ] && shift

## defaults
: "${debug:="0"}"



if fping -qx2 $TEST_HOSTS &>/dev/null ; then
    echo ""
else
    echo ""
fi

# vim: set ft=sh :

