#!/usr/bin/env python3
"""
Personal script to convert caldav calendar into human-readable
textfile (one event per line).

The idea is to print a summary of upcoming events once per day
to some xterm I just opened. This increases the chance that I
stay aware of things, compared to bio-polling a webpage or app.
"""
import os, sys, time

def fn(name):
    return os.path.join(os.getenv('HOME'), '.caldav-remind', name)
    
if not os.path.exists(fn('account')):
    sys.exit(0)
server, serverpath, user, pw = open(fn('account')).read().split()

# update the file even if there is an error
with open(fn('content'), 'w') as f:
    f.write('outdated\n')

import easywebdav
import icalendar
import datetime

webdav = easywebdav.connect(server, protocol='https', username=user, password=pw)
with open(fn('calendar.ical'), 'wb') as f:
    webdav.download(serverpath, f)

g = open(fn('calendar.ical'))
gcal = icalendar.Calendar.from_ical(g.read())
events = []
for component in gcal.walk():
    if component.name == "VEVENT":
        dt = component.decoded('dtstart')
        if isinstance(dt, datetime.datetime):
            dt = dt.date()
        events.append((dt, component))
g.close()

# keep a backup that persists over download errors
tmp_data = open(fn('calendar.ical'), 'rb').read()
if len(tmp_data) > 1000:
    open(fn('calendar_backup.ical'), 'wb').write(tmp_data)

show_days = 16
today = datetime.date.today()
d_min = today#+datetime.timedelta(days=1),
d_max = today+datetime.timedelta(days=show_days+1)


content = ''
for dt, event in sorted(events, key=lambda x: x[0]):
    if dt > d_max or dt < d_min:
        continue
    # too lazy to figure out locale stuff
    s = 'So Mo Di Mi Do Fr Sa'.split()[int(dt.strftime('%w'))] + ' '
    #s += dt.strftime('%a %d.%m. ')
    s += dt.strftime('%d.%m. ').replace('.0', '.')
    s = s.replace(' 0', '  ')
    hour = dt.strftime('%R')
    if hour != '00:00':
        s += hour + ' '
    s += event['SUMMARY']
    for name, value in list(event.items()):
        #print(repr((name, value)))
        if name in 'SUMMARY TRANSP UID CLASS STATUS'.split():
            continue
        if isinstance(value, str):
            if 'Ein Service von fcal.ch. NUR zum inter' in value:
                continue
            if value == 'TRUE' or value == 'FALSE':
                continue
            s += ', ' + value
    if len(s) > 79:
        s = s[:79-3] + '...'
    content += s + '\n'

if not content:
    content = 'no upcoming events\n'

# update the file even if there is an error
with open(fn('content'), 'w') as f:
    f.write(content)

