#!/usr/bin/env python3
import evdev
import asyncio
from evdev import ecodes
import socket
import subprocess
import sys
import time
from pynput import keyboard

print('trace 0', file=sys.stderr)
mplaylist = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
mplaylist.connect(('localhost', 28443))

fn = '/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd'
print('trace 1', file=sys.stderr)
device = evdev.InputDevice(fn)
print('trace 2', file=sys.stderr)
device.grab()  # prevent X11 from getting the events, too
print('trace 3', file=sys.stderr)

active_keycodes = set()


def volume_keys(keyset):
    plus = ecodes.KEY_KPPLUS in keyset
    minus = ecodes.KEY_KPMINUS in keyset
    if plus and minus:
        return
    elif plus:
        subprocess.call(['amixer', '-q', 'sset', 'Master', '1%+'])
        #subprocess.call(['amixer', '-q', 'sset', 'Master', '1%+'])
        #subprocess.call(['amixer', '-c', '1', '-q', 'sset', 'Master', '1%+'])
    elif minus:
        subprocess.call(['amixer', '-q', 'sset', 'Master', '1%-'])
        #subprocess.call(['amixer', '-q', 'sset', 'Master', '1%-'])
        #subprocess.call(['amixer', '-c', '1', '-q', 'sset', 'Master', '1%-'])


async def handle_active_keys():
    while active_keycodes:
        volume_keys(active_keycodes)
        await asyncio.sleep(0.07)


async def listen_to_numpad():
    active_key_task = None
    async for event in device.async_read_loop():
        if event.type != ecodes.EV_KEY:
            continue
        if event.value == 2:  # repeated
            continue
        if event.value == 0:  # released
            active_keycodes.remove(event.code)
        if event.value == 1:  # pressed
            active_keycodes.add(event.code)

            # execute one instant action
            #
            # When handle_active_keys() runs the key may already be released
            # again, because the key handler runs before the coroutine we start
            # right here... silly... this probably would have just worked
            # if it followed Javascript's Promises/A+ spec...
            volume_keys([event.code])
            if not active_key_task or active_key_task.done():
                active_key_task = asyncio.ensure_future(handle_active_keys())

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
        print(evdev.categorize(event), file=sys.stderr)

def on_press(key):
    if key == keyboard.Key.media_play_pause:
        mplaylist.send(b'P\n')
    if key == keyboard.Key.media_next:
        mplaylist.send(b'n\n')
    if key == keyboard.Key.media_previous:
        mplaylist.send(b'p\n')

print('numpad-trick.py: starting pynp keyboard listener')
listener = keyboard.Listener(on_press=on_press)
listener.start()

print('numpad-trick.py: starting asyncio loop', file=sys.stderr)

loop = asyncio.get_event_loop()
loop.run_until_complete(listen_to_numpad())
print('end of run_until_complete()', file=sys.stderr)
loop.close()
print('end of script', file=sys.stderr)

# asyncio.run(listen_to_numpad())
# loop = asyncio.get_event_loop()
# task = asyncio.create_task(listen_to_numpad())
# loop.run_forever()
