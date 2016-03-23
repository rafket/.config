#!/bin/sh
tint2 &
feh --bg-scale ~/Pictures/Wallpapers/mybabe.jpg
setxkbmap -layout "us,el" -option "grp:alt_shift_toggle" &
(sleep 1 && volumeicon) &
(sleep 1 && xscreensaver -no-splash) &
