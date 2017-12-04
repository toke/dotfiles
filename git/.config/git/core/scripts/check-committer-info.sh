#!/bin/bash

REMOTE=$(git config --get remote.origin.url)
USER=$(git config --local --get user.name)
ADDR=$(git config --local --get user.email)

# echo "===> Checking user settings ..."
# echo "* Remote : $REMOTE"
# echo "* User   : $USER"
# echo "* Mail   : $ADDR"

if [ -n "$USER" -a -n "$ADDR" ]; then
	# echo "Identity information already set, not updating ..."
	exit 0
fi

case "$REMOTE" in
	*bitbucket.1and1.org*)
		echo "INFO: Using user settings for 1&1"

		git config --local user.name "Thomas Kerpe"
		git config --local user.email "thomas.kerpe@1und1.de"
		git config --local user.signingkey "B5AD7FCB270DA76246D2A8F2B0E65607ABE57238"
		;;

	*)
		echo "INFO: Using user settings for public"

		git config --local user.name "Thomas Kerpe"
		git config --local user.email "toke@toke.de"
		git config --local user.signingkey "B5AD7FCB270DA76246D2A8F2B0E65607ABE57238"
		;;

esac
