#!/bin/bash

readonly apiurl="https://bitbucket.1and1.org/rest/api/latest"

readonly limit=200
readonly CURL='/usr/bin/curl -n -s'


function bitbucket () {

    case $1 in
        ls)
            _lsbitbucket $2 $3
            ;;
        list)
            _listbitbucket $2 $3
            ;;

        mkrepo)
            _mkbitbucket $2 $3
            ;;
        clone)
            _clonebitbucket $2 $3
            ;;
        info)
            _infobitbucket $2 $3
            ;;
        *)
            echo "bitbucket <clone> <ls> <mkrepo> <info>"
            ;;
    esac
}

function _mkbitbucket () {
    #
    # Creates a Bitbucket repository within a project
    #
    : ${2?Usage: <project> <repository>}

    local project_key="$1"
    local repo="$2"

    $CURL -X POST -H "Content-Type: application/json" -d "{\"name\": \"${repo}\", \"public\": true}" "${apiurl}/projects/${project_key}/repos/"
}


function _lsbitbucket () {
    #
    # List Bitbucket Server projects and repositories
    # When no parameter is given all visible project keys are shown
    # When a project-key is given all visible repository within the project is shown
    #
    # Usage: lsbitbucket [project-key]

    local project_key="$1"

    if [[ $project_key == "" ]] ; then
        $CURL "${apiurl}/projects/?limit=${limit}" | /usr/bin/jq -r '.values[].key'
    else
        $CURL "${apiurl}/projects/${project_key}/repos/?limit=${limit}" | /usr/bin/jq -r .values[].slug
    fi
}


function _listbitbucket () {
    #
    # List Bitbucket Server projects and repositories
    # When no parameter is given all visible project keys are shown
    # When a project-key is given all visible repository within the project is shown
    #
    # Usage: lsbitbucket [project-key]

    local project_key="$1"

    if [[ $project_key == "" ]] ; then
        $CURL "${apiurl}/projects/?limit=${limit}" | jq -r '.values | map([.key, .name] | join("\t")) | join("\n")'
    else
        $CURL "${apiurl}/projects/${project_key}/repos/?limit=${limit}" | /usr/bin/jq -r '.values | map([.slug, .name] | join("\t")) | join("\n")'
    fi
}




function _infobitbucket () {
    #
    # Creates a Bitbucket repository within a project
    #
    : ${1?Usage: <project> [repository]}

    local project_key="$1"
    local repo="$2"

    if [[ $repo == "" ]] ; then
        $CURL "${apiurl}/projects/${project_key}/" | jq .
    else
        $CURL "${apiurl}/projects/${project_key}/repos/${repo}/" | jq .
    fi
}

function _clonebitbucket () {

    : ${2?Usage: <project> <repository>}

    local project_key="$1"
    local repo="$2"

    git clone "$(_infobitbucket $1 $2 | jq -r '.links.clone[] | select(.name=="ssh").href')"

}
