#!/usr/bin/env sh

if [ `xrandr | grep -c ' connected '` -eq 3 ]; then
    xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 1920x1080 --pos 3840x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP1-3 --off --output DP1-2 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP1-1 --mode 1920x1080 --pos 0x0 --rotate normal
else
    xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP1-3 --off --output DP1-2 --off --output DP1-1 --off
fi
