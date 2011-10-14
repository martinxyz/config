#!/bin/bash

# http://www.x.org/wiki/Development/Documentation/PointerAcceleration

mouse=$(xinput list | grep 'Logitech USB Receiver'|cut -d= -f2|grep pointer|cut -f1|head -n1)

# scaling for higher resolution of device
xinput --set-prop $mouse "Device Accel Constant Deceleration" 2

# 2 - polynomial. Very useable, the recommended profile. (vs 0 - classic)
# velocity serves as the coefficient, acceleration being the exponent
xinput --set-prop $mouse "Device Accel Profile" 2

# This is the equivalent to "xset m b/c a"
# parameters are: a b c
# treshold (=velocity?) = a
# acceleration = b/c

# good values recommended by xorg doc
#xinput set-ptr-feedback "$mouse" 0 18 10

# my own tuning (seems to have no influence!)
#xinput set-ptr-feedback $mouse 0 21 10
xinput set-ptr-feedback $mouse 0 21 10

#xinput list-props $mouse
#echo mouse=$mouse

