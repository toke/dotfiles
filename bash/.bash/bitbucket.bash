#!/bin/bash

function mkbitbucket () {
    : ${2?Usage: mkbitbucket <project> <repository>}

    local apiurl="https://bitbucket.1and1.org/rest/api/latest"

    local project_key=$1
    local repo=$2


    curl -n -X POST -H "Content-Type: application/json" -d "{\"name\": \"${repo}\", \"public\": true}" "${apiurl}/projects/${project_key}/repos/"
}
