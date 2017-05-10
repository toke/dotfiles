#!/bin/bash

readonly apiurl="https://bitbucket.1and1.org/rest/api/latest"

readonly limit=200
readonly CURL='/usr/bin/curl -n -s'
readonly BBLOG="$HOME/bitbucket_client.log"

readonly GRAY="\033[1;30m"
readonly LIGHT_GRAY="\033[0;37m"
readonly GREEN="\033[1;32m"
readonly NO_COLOUR="\033[0m"


readonly USAGE="
bitbucket - shell client

Usage:
    bitbucket mkrepo <project> <repository>
    bitbucket ls [<project>|.]
    bitbucket list [<project>]
    bitbucket info <project> [<repository>]
    bitbucket diff [<project>|.]
    bitbucket clone <project> <repository>
    bitbucket sync [<project>|.]

Parameter:
    <project> is the Project Key like \"HBSS_ANSIBLE_ROLES\".
    <repository> is the Repository Key like \"essentials\".

Configuration:
    The Username and Password has to be set in ~/.netrc for
    bitbucket.1and1.org. Before doing so the password has to 
    be set in bitbucket (per default no password authentication
    possible).

"

function bitbucket () {

    echo "BEGIN $(date)" >> "$BBLOG"
    echo "$@" >> "$BBLOG"

    case $1 in
        ls)
            _bitbucket_ls $2 $3
            ;;
        list)
            _bitbucket_list $2 $3
            ;;
        mkrepo)
            _bitbucket_mk $2 $3
            ;;
        diff)
            _bitbucket_diff ${2-.}
            ;;
        clone)
            _bitbucket_clone $2 $3
            ;;
        info)
            _bitbucket_info $2 $3
            ;;
        sync)
            _bitbucket_sync $2
            ;;
        *)
            echo "$USAGE"
            ;;
    esac
    echo -e "\nEND $(date)" >> "$BBLOG"
}

function _bitbucket_cwp () {
    #
    # Heuristic approach of getting current working project
    # Currently assumes the current directory name is equal to project name
    local REGEXP='\b[A-Z0-9_\-]+\b'

    local project_key
    if [[ $1 == "." ]] ; then
        project_key=$(basename "$(pwd)"| grep -E "${REGEXP}")
    else
        project_key=$1
    fi
    echo "$project_key"
}

function _bitbucket_mk () {
    #
    # Creates a Bitbucket repository within a project
    #
    : "${2?Usage: <project> <repository>}"

    local project_key
    local repo
    project_key=$(_bitbucket_cwp "$1")
    repo="$2"

    $CURL -X POST -H "Content-Type: application/json" -d "{\"name\": \"${repo}\", \"public\": true}" "${apiurl}/projects/${project_key}/repos/"
}


function _bitbucket_ls () {
    #
    # List Bitbucket Server projects and repositories
    # When no parameter is given all visible project keys are shown
    # When a project-key is given all visible repository within the project is shown
    #
    # Usage: lsbitbucket [project-key|.]

    local project_key
    project_key=$(_bitbucket_cwp "$1")

    set -o pipefail

    if [[ $project_key == "" ]] ; then
        $CURL "${apiurl}/projects/?limit=${limit}" | /usr/bin/jq -r '.values[].key'
    else
        $CURL "${apiurl}/projects/${project_key}/repos/?limit=${limit}" | tee -a "$BBLOG" | /usr/bin/jq -r .values[].slug 2> /dev/null
    fi
}


function _bitbucket_list () {
    #
    # List Bitbucket Server projects and repositories
    # When no parameter is given all visible project keys are shown
    # When a project-key is given all visible repository within the project is shown
    #
    # Usage: lsbitbucket [project-key]

    local project_key
    project_key=$(_bitbucket_cwp "$1")

    set -o pipefail
    if [[ $project_key == "" ]] ; then
        $CURL "${apiurl}/projects/?limit=${limit}" | tee -a "$BBLOG" | jq -r '.values | map([.key, .name] | join("\t")) | join("\n")'
    else
        $CURL "${apiurl}/projects/${project_key}/repos/?limit=${limit}" | tee -a "$BBLOG" | /usr/bin/jq -r '.values | map([.slug, .name] | join("\t")) | join("\n")'
    fi
}


function _bitbucket_info () {
    #
    # Creates a Bitbucket repository within a project
    #
    : "${1?Usage: <project> [repository]}"

    local project_key
    local repo
    project_key=$(_bitbucket_cwp "$1")
    repo="$2"

    set -o pipefail
    if [[ $repo == "" ]] ; then
        $CURL "${apiurl}/projects/${project_key}/" | jq .
    else
        $CURL "${apiurl}/projects/${project_key}/repos/${repo}/" | jq .
    fi
}


function _bitbucket_geturl() {

    local project_key
    local repo
    project_key="$1"
    repo="$2"

    echo $(_bitbucket_info "$project_key" "$repo" | jq -r '.links.clone[] | select(.name=="ssh").href')
}

function _bitbucket_clone () {

    : "${2?Usage: <project> <repository>}"

    local project_key
    local repo
    project_key="$1"
    repo="$2"

    set -o pipefail
    git clone "$(_bitbucket_geturl "$project_key" "$repo")"

}

function __bitbucket_diff () {
    local tmp
    local project_key

    project_key=$(_bitbucket_cwp ${1-.})

    tmp=$(mktemp -d)
    set -o pipefail
    _bitbucket_ls "$project_key" | sort  > "$tmp/bb"


    find . -maxdepth 1 -type d -not -path '*/\.*' -not -path . -exec basename {} \; | sort > "$tmp/bl"
    #ls . | sort > "$tmp/bl"
    
    comm -3 "$tmp/bb" "$tmp/bl"
    rm -r "$tmp"
}

function _bitbucket_diff_side () {
    local diff
    local uniq
    local cmd
    local project_key

    cmd="$1"
    project_key="$(_bitbucket_cwp "${2-.}")"
    diff="$(__bitbucket_diff "$project_key")"

    case $cmd in
        local)
            uniq=$(echo "$diff" | grep -Pe '^\t' | tr -d '\t')
            ;;
        remote)
            uniq=$(echo "$diff" | grep -Pve "\t" | tr -d '\t')
            ;;
    esac
    echo "$uniq"
}

function _bitbucket_diff () {

    local diff
    local remoteonly
    local localonly
    local project_key

    project_key=$(_bitbucket_cwp "${1-.}")

    diff=$(__bitbucket_diff "$project_key")
    remoteonly=$(echo "$diff" | grep -vPe "\t" | tr -d '\t')
    localonly=$(echo "$diff" | grep -Pe '^\t' | tr -d '\t')

    echo -e "${LIGHT_GRAY}Bitbucket only:${NO_COLOUR}\n$remoteonly"
    echo -e "${LIGHT_GRAY}Local only:${NO_COLOUR}\n$localonly"
}


function _bitbucket_sync () {

    local project_key
    local prjdir

    (

    project_key=$(_bitbucket_cwp "${1-.}")
    if [ "$project_key" == "$(basename "$(pwd)")" ] ; then
        prjdir=.
    elif [ -d "$project_key" ] ; then
        prjdir="$project_key"
    else 
        echo "ERROR: create repository $project_key before continueing"
        return
    fi
    cd "$prjdir" || exit 1 

    for repo in  $(_bitbucket_diff_side remote $project_key) ; do
        _bitbucket_clone $project_key $repo
    done
    )
}
