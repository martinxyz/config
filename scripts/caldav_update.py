#!/usr/bin/env python
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
url, user, pw = open(fn('account')).read().split()
#print repr(url), repr(user), 'pw length', len(pw)

# update the file even if there is an error
with open(fn('content'), 'w') as f:
    f.write('outdated\n')

import caldav
from datetime import date, datetime, timedelta
import pytz
import icalendar

client = caldav.DAVClient(url, username=user, password=pw)
principal = caldav.Principal(client)
calendars = principal.calendars()
assert len(calendars) == 1, 'only a single calendar supported, for now'
calendar = calendars[0]

show_days = 30
results = calendar.date_search(
        datetime.now().date(),#+timedelta(days=1),
        datetime.now().date()+timedelta(days=show_days+1))

ical_results = []
for event in results:
  events = str(event)  
  cal = icalendar.Calendar.from_ical(event.data)
  assert len(cal.subcomponents) == 1
  event = cal.subcomponents[0]
  dt = event['DTSTART'].dt
  ical_results.append((dt, event))
 
content = ''
for dt, event in sorted(ical_results):
  # too lazy to figure out locale stuff
  s = 'So Mo Di Mi Do Fr Sa'.split()[int(dt.strftime('%w'))] + ' '
  #s += dt.strftime('%a %d.%m. ')
  s += dt.strftime('%d.%m. ').replace('.0', '.')
  s = s.replace(' 0', '  ')
  hour = dt.strftime('%R')
  if hour != '00:00':
      s += hour + ' '
  s += event['SUMMARY']
  for name, value in event.items():
      if name in 'SUMMARY TRANSP UID'.split():
          continue
      if isinstance(value, basestring):
          s += ', ' + value
  content += s + '\n'

if not content:
    content = 'no upcoming events\n'

# update the file even if there is an error
with open(fn('content'), 'w') as f:
    f.write(content.encode('utf-8'))

