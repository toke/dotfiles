#!/usr/bin/env python3

import os
from datetime import datetime
import yaml
from appdirs import *
from exchangelib import ServiceAccount, Configuration, Account, DELEGATE, EWSDateTime, EWSTimeZone

import zmq

appname = 'dev-timeline'
appauthor = 'toke'

class LocalCalendarItem(yaml.YAMLObject):
    yaml_tag = u'!calendarItem'
    reminder = None
    location = None
    item_id = None
    def __init__(self):
        self.subject = ''
        self.start   = None
        self.end     = None


class LocalCalendar(yaml.YAMLObject):
    yaml_tag = u'!calendar'
    def __init__(self):
        self.items = []


dataDir = user_data_dir(appname, appauthor)
configDir = user_config_dir(appname)
cacheDir  = user_cache_dir(appname, appauthor)
configFile = os.path.join(configDir, 'ews.yaml')

with open(configFile, mode='r') as cfg:
    userconfig = yaml.safe_load(cfg)

if not os.path.isdir(dataDir):
    os.mkdir(dataDir)

if not os.path.isdir(cacheDir):
    os.mkdir(cacheDir)


def connect():
    credentials = ServiceAccount(username=userconfig['ews']['username'], password=userconfig['ews']['password'])
    ews_config = Configuration(server=userconfig['ews']['server'], credentials=credentials)
    account = Account(
            config=ews_config,
            primary_smtp_address=userconfig['ews']['primary_smtp_address'],
            autodiscover=False,
            access_type=DELEGATE
    )
    return account


if __name__ == '__main__':

    account = connect()
    tz = EWSTimeZone.timezone('Europe/Berlin')

    d = datetime.today()
    year, month, day = (d.year, d.month, d.day)

    items = account.calendar.view(
        start   = tz.localize(EWSDateTime(year, month, day)),
        end     = tz.localize(EWSDateTime(year, month, day + 5))
        #,
        #categories__contains=['foo', 'bar'],
    )

    #qs = account.calendar.all()
    #qs.filter(start__range=(dt1, dt2))  # Returns items starting within range. Only for date and numerical types

    kal = LocalCalendar()

    for item in items:
        kali = LocalCalendarItem()
        kali.subject = item.subject
        # kali.start = item.start
        # kali.end = item.end
        kali.item_id = item.item_id
        kal.items.append(kali)

        #print(item.subject)
        print('%s:' % item.subject)
        print('\t%s - %s' % (item.start, item.end,))
        if item.reminder_due_by:
            print('\treminder: %s' % item.reminder_due_by)
        if item.reminder_minutes_before_start:
            print('\treminder mins: %s' % item.reminder_minutes_before_start)
        if item.location:
            print('\t@%s' % item.location)
        print(item.item_id)
        print(item.changekey)
        print(item.item_id)
        # print(item.mime_content)
    #print(item)
    #print(item.item_id)

    print(yaml.dump(kal))
    print(dir(item.end))
    print(item.start.date())
    print(dir(item.end))
    #print(datetime(item.start.timestamp()))
