#!/bin/bash

apiurl="https://bitbucket.1and1.org/rest/api/latest"

CURL=$'/usr/bin/curl -n -s -H "Content-Type: application/json"'


function bitbucket () {

    case $1 in
        ls)
            lsbitbucket $2 $3
            ;;
        mkrepo)
            mkbitbucket $2 $3
            ;;
        info)
            infobitbucket $2 $3
            ;;
        *)
            echo "bitbucket <ls> <mkrepo> <info>"
            ;;
    esac
}

function mkbitbucket () {
    #
    # Creates a Bitbucket repository within a project
    #
    : ${2?Usage: mkbitbucket <project> <repository>}

    local project_key="$1"
    local repo="$2"

    $CURL -X POST -d "{\"name\": \"${repo}\", \"public\": true}" "${apiurl}/projects/${project_key}/repos/"
}


function lsbitbucket () {
    #
    # List Bitbucket Server projects and repositories
    # When no parameter is given all visible project keys are shown
    # When a project-key is given all visible repository within the project is shown
    #
    # Usage: lsbitbucket [project-key]

    local project_key="$1"

    if [[ $project_key == "" ]] ; then
        $CURL "${apiurl}/projects/" | /usr/bin/jq -r .values[].key
    else
        $CURL "${apiurl}/projects/${project_key}/repos/" | /usr/bin/jq -r .values[].slug
    fi
}


function infobitbucket () {
    #
    # Creates a Bitbucket repository within a project
    #
    : ${2?Usage: mkbitbucket <project> <repository>}

    local project_key="$1"
    local repo="$2"

    $CURL "${apiurl}/projects/${project_key}/repos/${repo}/" | jq .
}


