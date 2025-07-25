#!/usr/bin/env python3
#
# Service: ~/.config/systemd/user/numpad-trick.service
# [Unit]
# Description=numpad-trick.py - grabs keypad input
# 
# [Service]
# Restart=on-failure
# RestartSec=8
# ExecStart=/usr/bin/python3 -u %h/code/scripts/numpad-trick.py
# 
# [Install]
# WantedBy=default.target

import evdev
import asyncio
from evdev import ecodes
import socket
import subprocess
import sys
import time
from pynput import keyboard

fn = '/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd'
device = evdev.InputDevice(fn)
device.grab()  # prevent X11 from getting the events, too

active_keycodes = set()

token_bucket = 0.0
token_bucket_updated_ts = 0
def limit():
    global token_bucket, token_bucket_updated_ts
    ts = time.monotonic()
    dt = ts - token_bucket_updated_ts
    token_bucket_updated_ts = ts
    token_bucket += dt * 0.9  # key events per second allowed (long-term)
    token_bucket = min(token_bucket, 5)  # burst allowed
    token_bucket -= 1
    # print(f'token_bucket: {token_bucket:.3f} dt was {dt:.3f}')
    if token_bucket < 1:
        token_bucket = 0
        print('token_bucket depleted, dropping key press', file=sys.stderr)
        return True
    return False

def mplaylist_send(s):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect(('localhost', 28443))
        sock.send(s)
    except Exception as e:
        print('Failed to send to mplaylist:\n', e, file=sys.stderr)
    finally:
        sock.close()


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
    while active_keycodes:    # could just use device.active_keys?
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
                if limit(): continue
                mplaylist_send(b'\n')
            if event.code == ecodes.KEY_KP1:
                if limit(): continue
                mplaylist_send(b'p\n')
            if event.code == ecodes.KEY_KP2:
                if limit(): continue
                mplaylist_send(b'n\n')
            if event.code == ecodes.KEY_KP0:
                if limit(): continue
                mplaylist_send(b's\n')
        if event.code == ecodes.KEY_NUMLOCK:
            continue
        print(evdev.categorize(event), file=sys.stderr)

def on_press(key):
    try:
        if key == keyboard.Key.media_play_pause:
            if limit(): return
            mplaylist_send(b'P\n')
        if key == keyboard.Key.media_next:
            if limit(): return
            mplaylist_send(b'n\n')
        if key == keyboard.Key.media_previous:
            if limit(): return
            mplaylist_send(b'p\n')
    except Exception as e:
        print(e)
        time.sleep(5)
        print('Exiting with error.')
        sys.exit(1)

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
