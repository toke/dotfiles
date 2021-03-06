#!/usr/bin/env python3

import os
import time
import json
import requests
import yaml
import webbrowser


CONFIG_FILE = os.path.expanduser("~/.config/octoclient/config.yml")

with open(CONFIG_FILE, 'r') as stream:
    try:
        config = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)

try:
    key = os.environ['BLOCK_INSTANCE']
except KeyError:
    key = "default"

pconfig = config["printer"][key]

if 'BLOCK_BUTTON' in os.environ and os.environ['BLOCK_BUTTON'] == "1":
    w = webbrowser.get('firefox')
    w.open(pconfig["baseUrl"])

if "basicAuth" in pconfig:
    auth = (pconfig["basicAuth"]["user"], pconfig["basicAuth"]["pass"])
headers = {"X-Api-Key": pconfig["apiKey"]}
r = requests.get(pconfig["url"], auth=auth, headers=headers, verify=True)

res = r.json()

etl = time.strftime('%H:%M:%S', time.gmtime(res['progress']['printTimeLeft']))
if res['state'] == 'Printing':
    icon = '\uf0c3'
else:
    icon = '\uf06a'

res['progress']['etl'] = etl
res['progress']['icon'] = icon

i3block = {}
i3block['label'] = icon
i3block['full_text'] = '{progress[icon]} {progress[completion]:.01f}% {progress[etl]}'.format(**res)
i3block['short_text'] = '{progress[icon]} {progress[completion]:.01f}%'.format(**res)
print(json.dumps(i3block, ensure_ascii=False))
