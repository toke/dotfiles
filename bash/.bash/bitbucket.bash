#!/bin/bash

apiurl="https://bitbucket.1and1.org/rest/api/latest"

CURL='/usr/bin/curl -n -s -H "Content-Type: application/json"'

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

