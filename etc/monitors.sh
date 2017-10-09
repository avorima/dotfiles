# vim: tw=99: cc=100:
#!/bin/sh

# Get out of town if something errors
# set -e

# Get info on the monitors
dpi1_status=$(</sys/class/drm/card0/card0-DP-2/status)
dpi2_status=$(</sys/class/drm/card0/card0-DP-3/status)

hdmi_status=$(</sys/class/drm/card0/card0-HDMI-A-1/status)

state_log=/tmp/monitor-state

# Check to see if a state log exists
if [[ ! -f $state_log ]]; then
    touch $state_log
    state=5
else
    state=$(<$state_log)
fi

1080p='--mode 1920x1080 --rotate normal'

# The state log has the NEXT state to go to in it

disabled_outputs='--output VIRTUAL1 --off --output DP1 --off --ouput HDMI1 --off --output HDMI2 --off --output DP1-3 --off'

# xrandr $disabled_outputs --output eDP1 --primary $1080p --pos 0x0 --output DP1-1 $1080p --pos 1920x0 --output DP1-2 $1080p --pos 3840x0

# If monitors are disconnected, stay in state 1
if [[ "disconnected" == $dpi1_status ]] && [[ "disconnected" = $dpi2_status ]]; then
    state=1
fi

case $state in
    1)
        echo "laptop display on, projectors not connected"
        # xrandr --output eDP-1 --auto
        state=2
        ;;
    2)
        echo "Laptop display is on, projectors are connected but inactive"
        # xrandr --output eDP-1 --auto --output DP1-1 --off --output DP1-2 --off
        state=3
        ;;
    3)
        echo "Laptop display is off, projectors are on"
        if [[ "connected" == $dpi1_status ]] && [[ "connected" == $dpi2_status ]]; then
            # xrandr $disabled_outputs --output eDP1 --off --output DP1-1 $1080p --pos 0x0 --output DP1-2 $1080p --pos 1920x0
            # xrandr --output eDP-1 --off --output DP1-1 --auto --output DP1-2 --auto
            type="DP"
        fi
        notify-send -t 5000 --urgency=low "Graphics Update" "Switched to $type"
        state=4
        ;;
    4)
        echo "Laptop display is on, projectors are mirroring"
        if [[ "connected" == $dpi1_status ]] && [[ "connected" == $dpi2_status ]]; then
            # xrandr --output eDP-1 --auto --output HDMI-1 --auto
            type="DP"
        fi
        notify-send -t 5000 --urgency=low "Graphics Update" "Switched to $type mirroring"
        state=5
        ;;
    5)
        echo "Laptop display is on, projectors are extending"
        if [[ "connected" == $dpi1_status ]] && [[ "connected" == $dpi2_status ]]; then
            # xrandr --output eDP-1 --auto --output DP1-1 --auto --left-of eDP-1
            type="DP"
        fi
        notify-send -t 5000 --urgency=low "Graphics Update" "Switched to $type extending"
        state=2
        ;;
    *)
        echo "Unknown state, assume we're in 1"
        state=1
esac

echo $state > $state_log
