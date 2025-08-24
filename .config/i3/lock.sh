#!/bin/bash

icon="$HOME/.config/i3/lock.png"
tmpbg='/tmp/screen.png'

scrot $tmpbg
convert $tmpbg -scale 10% -scale 1000% $tmpbg

if [[ -f $icon ]]; then
    # placement x/y
    px=0
    py=0
    # lockscreen image info
    lock=$(file $icon | grep -o '[0-9]* x [0-9]*')
    lockX=$(echo $lock | cut -d' ' -f 1)
    lockY=$(echo $lock | cut -d' ' -f 3)

    monitors=$(xrandr --query | grep ' connected' | sed -e 's/primary //g' | cut -d' ' -f3)
    for res in $monitors; do
        # monitor position/offset
        posX=$(echo $res | cut -d'x' -f 1)
        posY=$(echo $res | cut -d'x' -f 2 | cut -d'+' -f 1)
        offX=$(echo $res | cut -d'x' -f 2 | cut -d'+' -f 2)
        offY=$(echo $res | cut -d'x' -f 2 | cut -d'+' -f 3)
        px=$(($offX + $posX/2 - $lockX/2))
        py=$(($offY + $posY/2 - $lockY/2))

        convert $tmpbg $icon -geometry +$px+$py -composite -matte $tmpbg
        echo "done"
    done
fi

i3lock -e -u -n -i $tmpbg

# [[ -f ~/.config/i3/lock.png ]] && convert /tmp/screen.png ~/.config/i3/lock.png -gravity center -composite -matte /tmp/screen.png
# i3lock -u -i /tmp/screen.png
# rm /tmp/screen.png
