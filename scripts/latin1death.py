#!/usr/bin/env python3
import os

d = b'/musik/sammlung'
for fn in list(os.listdir(d)):
    try:
        fn_unicode = fn.decode('utf-8')
    except:
        fn_unicode = fn.decode('latin-1')
        print(fn, fn_unicode)
        os.rename(os.path.join(d, fn), os.path.join(d, fn_unicode.encode('utf-8')))

