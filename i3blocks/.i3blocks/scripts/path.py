#!/usr/bin/env python
import i3ipc
import sys

i3 = i3ipc.Connection()

def on_window_focus(i3, e):
    focused = i3.get_tree().find_focused()
    if len(focused.name) > 21:
        #print('{{"full_text":"{}…"}}'.format(focused.name[:20]))
        print('{}…'.format(focused.name[:20]))
    else:
        #print('{{"full_text":"{}"}}'.format(focused.name))
        print(focused.name)
    sys.stdout.flush()

on_window_focus(i3, None)

i3.on('window::focus', on_window_focus)

i3.main()
