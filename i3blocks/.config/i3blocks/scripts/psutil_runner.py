#!/usr/bin/env python3

import os
import json
from threading import Timer
from humanfriendly import format_size
import psutil as ps


class Reentrant(object):
    INTERVAL = 5
    DEFAULT_INSTANCE = None

    def __init__(self, instance="/"):
        self.instance = instance
        self.short_text = ""
        self.full_text = ""

    def run(self):
        print("Override me", flush=True)

    def event(self, event=None):
        print(json.dumps({"full_text": '<span font_desc=\'FontAwesome\'>\u263a \uf2cb \U0001f50b [<i>Testing</i>]</span><sup>+1</sup>Handling event={}'.format(event)},ensure_ascii=False), flush=True)

    def _to_json(self, data={}):
        doc = data
        doc["short_text"] = self.short_text
        doc["full_text"] = self.full_text
        print(json.dumps(doc, ensure_ascii=False, indent=None), flush=True)

    def loop(self):
        if self.INTERVAL and self.INTERVAL > 0:
            Timer(
              self.INTERVAL,
              self.loop,
            ).start()
        self.run()

class DfBlock(Reentrant):
    DEFAULT_INSTANCE = "/"
    INTERVAL = None

    def run(self):
        p_color = ""
        disk = ps.disk_usage(self.instance)
        if disk.percent >= 90:
            p_color = " color=\'#f44\'"
        self.full_text = "{} (<span{}>{}%</span>)".format(format_size(disk.free), p_color, disk.percent)
        self.short_text = "<span{}>{}%</span>".format(p_color, disk.percent)

        self._to_json()


class NetIoBlock(Reentrant):
    INTERVAL = 1

    def __init__(self, instance=None, **kwargs):
        self.in_bytes = None
        self.out_bytes = None
        super(NetIoBlock, self).__init__(**kwargs)

    def run(self):
        netio = ps.net_io_counters()
        if self.in_bytes and self.out_bytes:
            bw_in  = (netio.bytes_recv - self.in_bytes)
            bw_out = (netio.bytes_sent - self.out_bytes)
            self.short_text = " {:5.1f}k".format((bw_in / 1024))
            self.full_text = " {:5.1f}kb/s  {:5.1f}kb/s".format((bw_in / 1024), (bw_out / 1024))

        self._to_json()

        self.in_bytes = netio.bytes_recv
        self.out_bytes = netio.bytes_sent


class TimeBlock(Reentrant):
    INTERVAL = 1

    def run(self):
        from datetime import datetime
        print (datetime.now(), flush=True)


CMD_CONF = {
    "df": {
        "class": DfBlock,
        "default_instance": "/"
    },
    "netio": {
        "class": NetIoBlock,
        "default_instance": None
    },
    "time": {
        "class": TimeBlock,
        "default_instance": None
    }
}


if __name__ == '__main__':
    block_name     = os.getenv("BLOCK_NAME", "df")
    block_instance = os.getenv("BLOCK_INSTANCE", CMD_CONF[block_name]["default_instance"])
    block_button   = os.getenv("BLOCK_BUTTON", "")

    # BLOCK_NAME
    # BLOCK_INSTANCE
    # BLOCK_BUTTON

    clss = CMD_CONF[block_name]["class"]
    if block_button is not None and block_button != "":
        clss(instance=block_instance).event(event=block_button)
    else:
        inst = clss(instance=block_instance)
        inst.loop()
