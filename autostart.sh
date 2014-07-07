#!/bin/bash
xset b 12
xmodmap  /home/martin/config/xmodmaps/reld
( sleep 3; xmodmap  /home/martin/config/xmodmaps/reld ; ) &
psi &
thunderbird &
( cd /home/martin/fft; ./telefon_simple.py >> /home/martin/fft/telefon_simple_autostart.log & )
#yakuake &

