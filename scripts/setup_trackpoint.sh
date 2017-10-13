#!/bin/sh
# vim:et:sw=4

possible_ids=$(xinput list | awk '/ThinkPad.*slave\s+pointer/ { split($9,xinp,"=");print xinp[2] }')

# figure out if trackpoint is xinput id 12 or 13:
# Trackpoint has button middle and touchpad doesn't
for id in $possible_ids; do
    xinput list-props $id | grep "Button Middle" >/dev/null
    if [ $? -eq 0 ]; then
        TP_DEVICE=$id
    else
        # disable touchpad
        xinput disable $id
    fi
done
devinput=$(xinput list-props $TP_DEVICE | grep "Device Node" | cut -d\" -f2)
echo "TrackPoint is Device $TP_DEVICE ($devinput)"

xinput enable $TP_DEVICE
xinput set-prop $TP_DEVICE "Evdev Wheel Emulation" 1
xinput set-prop $TP_DEVICE "Evdev Wheel Emulation Button" 2
