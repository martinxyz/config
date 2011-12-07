stylus="Wacom Intuos3 6x8"
pad="Wacom Intuos3 6x8 pad"

#xsetwacom set cursor SpeedLevel 7.5
#xsetwacom set "$pad" Button1 "core key alt"
#xsetwacom set "$pad" Button2 "core key shift"
#xsetwacom set "$pad" Button3 "core key ctrl"
#xsetwacom set "$pad" Button4 "core key super"
#xsetwacom set "$pad" striplup "core key up"
#xsetwacom set "$pad" stripldn "core key down"

xsetwacom set "$pad" button1 "core key ctrl alt 1"
xsetwacom set "$pad" button2 "core key ctrl alt 2"
xsetwacom set "$pad" button3 "core key ctrl alt 3"
xsetwacom set "$pad" button4 "core key ctrl alt 4"
xsetwacom set "$pad" button5 "core key ctrl alt 5"
xsetwacom set "$pad" button6 "core key ctrl alt 6"
xsetwacom set "$pad" button7 "core key ctrl alt 7"
xsetwacom set "$pad" button8 "core key ctrl alt 8"
xsetwacom set "$pad" button9 "core key ctrl alt 9"

(( w = 40640 )) # intuos active area
(( h = 30480 )) # intuos active area
# 1920 1080 <-- wide screen (16:9)
(( w2 = w*6/10 ))
(( h2 = w2*9/16 ))
(( topx = 0 ))
(( topy = h - h2 ))
(( bottomx = topx + w2 ))
(( bottomy = topy + h2 ))

xsetwacom set "$stylus" topx $topx
xsetwacom set "$stylus" topy $topy
xsetwacom set "$stylus" bottomx $bottomx
xsetwacom set "$stylus" bottomy $bottomy

xsetwacom set "$pad" StripLUp None
xsetwacom set "$pad" StripRUp None
xsetwacom set "$pad" StripLDn None
xsetwacom set "$pad" StripRDn None

