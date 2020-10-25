#!/usr/bin/env python3

#interval = 60*60
interval = 60*60*9

import os, sys, time

# my old calendar: hand-edited text file, one event per line
f = os.path.join(os.getenv('HOME'), 'notes', 'cal')
if os.path.exists(f) and \
   time.time() - os.path.getmtime(f) >= interval:
    data = open(f).read()
    data = data.split('\n---')[1]
    lines = [s for s in data.split('\n')[1:] if s.strip()]
    lines = lines[:3]
    if ''.join(lines).strip():
        # calendar not empty
        print()
        for line in lines:
            print(line[:80])
        print()
        os.utime(f, None) # touch

# my new calendar: read-only text file, synced via caldav
def fn(name):
    return os.path.join(os.getenv('HOME'), '.caldav-remind', name)
if os.path.exists(fn('content')):
    if not os.path.exists(fn('last-shown')) or \
       time.time() - os.path.getmtime(fn('last-shown')) >= interval:
        data = open(fn('content')).read()
        lines = [s for s in data.split('\n') if s.strip()]
        lines = lines[:3]
        if ''.join(lines).strip():
            # calendar not empty
            print()
            for line in lines:
                print(line[:80])
            print()
            with open(fn('last-shown'), 'w'): pass # touch or create
