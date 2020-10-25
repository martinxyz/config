#!/usr/bin/env python3

#interval = 60*60
interval = 60*60*9

import os, sys, time

# read-only text file, synced via caldav
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
            print(file=sys.stderr)
            for line in lines:
                print(line[:80], file=sys.stderr)
            print(file=sys.stderr)
            with open(fn('last-shown'), 'w'): pass # touch or create
