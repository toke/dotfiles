#!/bin/bash
#
# Bash helper functions
#


#
# Helper for allowing only aliases to existing commands
# Similar to [ -e /usr/bin/translate-shell ] && alias abc="/usr/bin/abc"
#
function bin_alias {
    local aliasname="$1"
    local aliascontent="$2"

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
    local array=(${1//@/ })
    local host=""
    local user=""
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

    local dns="@a.ns.kerpe.net" # dig syntax @ns
    $(dig +short -t SRV "_ssh._tcp.${host}" ${dns} \
        | awk -v USER="${user}" -e 'BEGIN{ printf "cssh " USER} /^[a-zA-Z0-9\.\-_ ]+$/ { printf  " " $4;} END {print "";}')
}


function _color {
    local c

    case $1 in
        "black")
            c=30 ;;
        "red")
            c=31 ;;
        "green")
            c=32 ;;
        "yellow")
            c=33 ;;
        *)
            c=39 ;;
    esac

    echo -en "\e[${c}m"
}

function cecho {
    local COLOR="$1"
    local STRING="$2"
    local esc=""
    local reset="\e[0m"
    
    case $COLOR in

        "bold")
            esc="\e[1m" ;;
        "dim")
            esc="\e[2m" ;;
        "reverse")
            esc="\e[7m" ;;
        "red")
            esc="\e[31m" ;;
        "yellow")
            esc="\e[93m" ;;
        "cyan")
            esc="\e[36m" ;;
        *)
            ;;
    esac

    echo -ne "${esc}${STRING}${reset}"

}
