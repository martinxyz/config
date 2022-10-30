#!/usr/bin/env python
import pyinotify
import os, time, subprocess

directory = '/home/martin/tmp/autoplay'
wm = pyinotify.WatchManager()
mask = pyinotify.IN_CREATE # watched events

class EventHandler(pyinotify.ProcessEvent):
    def process_IN_CREATE(self, event):
        print "Processing", event.pathname
        time.sleep(3)
        subprocess.call(['mpv', os.path.join(directory, event.pathname)])
    def process_IN_MOVED_TO(self, event):
        print 'MOVED_TO'
    def process_IN_MOVED_FROM(self, event):
        print 'MOVED_FROM'

handler = EventHandler()
notifier = pyinotify.Notifier(wm, handler)
wdd = wm.add_watch(directory, mask, rec=False)
notifier.loop()

