#!/usr/bin/env python3
import evdev
import asyncio
from evdev import ecodes
import socket
import subprocess

fn = '/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd'
device = evdev.InputDevice(fn)
device.grab()  # prevent X11 from getting the events, too

mplaylist = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
mplaylist.connect(('localhost', 28443))


async def print_events():
    async for event in device.async_read_loop():
        if event.type != ecodes.EV_KEY:
            continue
        if event.value == 1 or event.value == 2:
            if event.code == ecodes.KEY_KPMINUS:
                subprocess.call(['amixer', 'sset', 'Master', '1%-'])
            if event.code == ecodes.KEY_KPPLUS:
                subprocess.call(['amixer', 'sset', 'Master', '1%+'])
        if event.value == 2:  # repeated
            continue
        if event.value == 1:  # pressed
            if event.code == ecodes.KEY_KPENTER:
                mplaylist.send(b'\n')
            if event.code == ecodes.KEY_KP1:
                mplaylist.send(b'p\n')
            if event.code == ecodes.KEY_KP2:
                mplaylist.send(b'n\n')
            if event.code == ecodes.KEY_KP0:
                mplaylist.send(b's\n')
        if event.code == ecodes.KEY_NUMLOCK:
            continue
        print(evdev.categorize(event))
        # print(event.value) # 0 or 1

loop = asyncio.get_event_loop()
asyncio.ensure_future(print_events())
loop.run_forever()
