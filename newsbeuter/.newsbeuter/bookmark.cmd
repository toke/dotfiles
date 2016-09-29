#!/bin/sh
url="$1"
title="$2"
description="$3"

echo -e "${url}\t${title}\t${description}" >> ~/bookmarks.txt

echo "${url}" | pockyt put -i redirect
