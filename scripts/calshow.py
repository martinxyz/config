#!/usr/bin/env python

#interval = 60*60
interval = 60*60*5

import os, sys, time
f = os.path.join(os.getenv('HOME'), 'notes', 'cal')
if not os.path.exists(f):
    sys.exit(0)
if time.time() - os.path.getmtime(f) < interval:
    sys.exit(0)

data = open(f).read()
data = data.split('\n---')[1]
lines = [s for s in data.split('\n')[1:] if s.strip()]
lines = lines[:3]
print
for line in lines:
    print line[:80]
print
os.utime(f, None) # touch

