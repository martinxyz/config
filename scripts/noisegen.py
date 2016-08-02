#!/usr/bin/env python
"""
Play stationary noise forever (e.g. to mask other sounds).
"""
from time import time
import alsaaudio

#from pylab import *
from scipy import signal
from numpy import array, zeros
from numpy.random import randn
import scipy.signal as signal

N = 512
fs = 44100
frame_duration = float(N)/fs

outp = alsaaudio.PCM(alsaaudio.PCM_PLAYBACK)
outp.setchannels(2)
outp.setrate(fs)
outp.setformat(alsaaudio.PCM_FORMAT_S16_LE)
outp.setperiodsize(N)

# filter coefficients
b, a = [0.1], [1, 0.9]
# bandstop:
#b,a = signal.iirdesign(wp = [0.05, 0.3], ws= [0.02, 0.35], gstop= 60, gpass=1, ftype='ellip')

# "entfernter fluss, tiefer wind"
#b,a = signal.iirdesign(wp=0.01, ws=0.4, gstop=60, gpass=1, ftype='ellip')

# "fluss"
#b,a = signal.iirdesign(wp=0.02, ws=0.4, gstop=60, gpass=1, ftype='ellip')
# "flugzeug"
#b,a = signal.iirdesign(wp=0.03, ws=0.4, gstop=60, gpass=1, ftype='ellip')
# "wasserfall"
b,a = signal.iirdesign(wp=0.06, ws=0.8, gstop=60, gpass=1, ftype='ellip')
# "gasleck"
#b,a = signal.iirdesign(wp=0.5, ws=0.1, gstop=60, gpass=1, ftype='ellip')
# "fieses zirpen"
#f=0.4; b,a = signal.iirdesign(wp=f+0.05, ws=f, gstop=60, gpass=1, ftype='ellip')
# "ueberlauf I"
#f=0.3; b,a = signal.iirdesign(wp=f+0.0005, ws=f, gstop=60, gpass=1, ftype='ellip')
# "ueberlauf II"
#f=0.8; b,a = signal.iirdesign(wp=f+0.0009, ws=f, gstop=60, gpass=1, ftype='ellip')

zi = zeros(max(len(b), len(a))-1)

while 1:
    out = randn(N) * 0.1
    #out += sin(linspace(0,20*pi,N))

    out, zi = signal.lfilter(b, a, out, zi=zi)

    data = array(out*32768, 'int16')
    res = outp.write(data)

    if res <= 0:
        print 'ERR', res

