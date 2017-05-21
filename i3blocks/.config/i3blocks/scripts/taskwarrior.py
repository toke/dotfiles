#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
from taskw import TaskWarrior

label = '◔'
ret = {
    'name': 'taskwarrior',
    'align': 'left',
    'label': label
}
w = TaskWarrior()

context = w.config["context"]

active = w.filter_tasks({'start.isnt': None})
if active:
    ret['short_text'] = str(active[0]['id'])
    ret['full_text'] = str.format("{0}{1[id]}: {1[description]}", label, active[0])
else:
    ret['short_text'] = ""
    ret['full_text'] = "none"

#if context == 'work':
#  print(json.dumps(ret))

print(json.dumps(ret, ensure_ascii=False))
