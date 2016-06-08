#!/bin/bash
#
# Helper for allowing only aliases to existing commands
# Similar to [ -e /usr/bin/translate-shell ] && alias abc="/usr/bin/abc"
#
function bin_alias {
	aliasname="$1"
	aliascontent="$2"

  if [[ -z "$aliasname" && -z $aliascontent ]] ; then
    echo "Call $0 alias-name alias-value"
    echo "Sets alias only if alias-value is a known command (see man 1 command)"
    exit 1
  else
    command -v "$aliascontent" > /dev/null && \
    		alias $aliasname="$aliascontent"
  fi
}

#
# Calls cssh with the result of the _ssh._tcp records for Host.
# srv-cssh user@host # user@ is optional
# host needs _ssh._tcp. SRV DNS RR
# All listed hosts will be connected
#
function srv-cssh {
    array=(${1//@/ })
    if [[ -z ${array[0]} ]] ; then
        echo "Usage: srv-cssh [user@]host"
        return 1
    elif [[ -z ${array[1]} ]] ; then
        host=${array[0]}
        user=""
    else
        host=${array[1]}
        user="-l ${array[0]}"
    fi

    dns="@a.ns.kerpe.net" # dig syntax @ns
    $(dig +short -t SRV "_ssh._tcp.${host}" ${dns} \
        | awk -v USER="${user}" -e 'BEGIN{ printf "cssh " USER} /^[a-zA-Z0-9\.\-_ ]+$/ { printf  " " $4;} END {print "";}')
}
