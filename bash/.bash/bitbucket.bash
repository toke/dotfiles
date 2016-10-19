#!/bin/bash

readonly apiurl="https://bitbucket.1and1.org/rest/api/latest"

readonly limit=200
readonly CURL='/usr/bin/curl -n -s'

GRAY="\033[1;30m"
LIGHT_GRAY="\033[0;37m"
GREEN="\033[1;32m"
NO_COLOUR="\033[0m"


function bitbucket () {

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
            _bitbucket_diff
            ;;
        clone)
            _bitbucket_clone $2 $3
            ;;
        info)
            _bitbucket_info $2 $3
            ;;
        *)
            echo "bitbucket <clone> <diff> <ls> <list> <mkrepo> <info>"
            ;;
    esac
}

function _bitbucket_cwp () {
    #
    # Heuristic approach of getting current working project
    # Currently assumes the current directory name is equal to project name

    local project_key
    if [[ $1 == "." ]] ; then
        project_key=$(basename $(pwd))
    else
        project_key=$1
    fi
    echo "$project_key"
}

function _bitbucket_mk () {
    #
    # Creates a Bitbucket repository within a project
    #
    : ${2?Usage: <project> <repository>}

    local project_key="$1"
    local repo="$2"

    $CURL -X POST -H "Content-Type: application/json" -d "{\"name\": \"${repo}\", \"public\": true}" "${apiurl}/projects/${project_key}/repos/"
}


function _bitbucket_ls () {
    #
    # List Bitbucket Server projects and repositories
    # When no parameter is given all visible project keys are shown
    # When a project-key is given all visible repository within the project is shown
    #
    # Usage: lsbitbucket [project-key|.]

    local project_key=$(_bitbucket_cwp $1)

    if [[ $project_key == "" ]] ; then
        $CURL "${apiurl}/projects/?limit=${limit}" | /usr/bin/jq -r '.values[].key'
    else
        $CURL "${apiurl}/projects/${project_key}/repos/?limit=${limit}" | /usr/bin/jq -r .values[].slug
    fi
}


function _bitbucket_list () {
    #
    # List Bitbucket Server projects and repositories
    # When no parameter is given all visible project keys are shown
    # When a project-key is given all visible repository within the project is shown
    #
    # Usage: lsbitbucket [project-key]

    local project_key=$(_bitbucket_cwp $1)

    if [[ $project_key == "" ]] ; then
        $CURL "${apiurl}/projects/?limit=${limit}" | jq -r '.values | map([.key, .name] | join("\t")) | join("\n")'
    else
        $CURL "${apiurl}/projects/${project_key}/repos/?limit=${limit}" | /usr/bin/jq -r '.values | map([.slug, .name] | join("\t")) | join("\n")'
    fi
}




function _bitbucket_info () {
    #
    # Creates a Bitbucket repository within a project
    #
    : ${1?Usage: <project> [repository]}

    local project_key=$(_bitbucket_cwp $1)
    local repo="$2"

    if [[ $repo == "" ]] ; then
        $CURL "${apiurl}/projects/${project_key}/" | jq .
    else
        $CURL "${apiurl}/projects/${project_key}/repos/${repo}/" | jq .
    fi
}

function _bitbucket_clone () {

    : ${2?Usage: <project> <repository>}

    local project_key=$(_bitbucket_cwp $1)
    local repo="$2"

    git clone "$(_bitbucket_info $project_key $repo | jq -r '.links.clone[] | select(.name=="ssh").href')"

}


function _bitbucket_diff () {
    local tmp=$(mktemp -d)
    _bitbucket_ls . | sort  > $tmp/bb
    ls . | sort > $tmp/bl

    local bbonly=$(comm -2 -3 $tmp/bb $tmp/bl)
    local localonly=$(comm -1 -3 $tmp/bb $tmp/bl)
    rm -r "$tmp"

    echo -e "${LIGHT_GRAY}Bitbucket only:${NO_COLOUR}\n$bbonly"
    echo -e "${LIGHT_GRAY}Local only:${NO_COLOUR}\n$localonly"
}
