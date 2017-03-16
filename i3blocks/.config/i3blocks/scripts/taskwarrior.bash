#!/bin/env bash

source /home/toke/.virtualenvs/default/bin/activate

case $BLOCK_BUTTON in
    1)
        st -T taskwin -e ~/bin/display_tasks.sh
    ;;
    *)
        echo "HUH";;

esac

# Only Show when in work context
if [ $(task context show | gawk -F $'\'' '{ print $2 }') == 'work' ]
then

task +ACTIVE export| jq '{"name": "taskwarrior", "short_text": .[0].id | tostring, "full_text": "\(.[0].id | tostring): \(.[0].description)", "align": "left", "label": "◔"}'

fi


#ask +ACTIVE export| jq '{"short_name": [.[].id|tostring]|join(","), "long_name": [.[].description]|join(", ")}'

