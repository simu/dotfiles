#!/bin/sh

# figure out if trackpoint is xinput id 12 or 13:
# Trackpoint has button middle and touchpad doesn't
xinput list-props 12 | grep "Button Middle" >/dev/null
if [ $? -eq 0 ]; then
	TP_DEVICE=12
	# disable touchpad
	xinput disable 13
else
	xinput list-props 13 | grep "Button Middle" >/dev/null
	if [ $? -eq 0 ]; then
		TP_DEVICE=13
		# disable touchpad
		xinput disable 12
	fi
fi
devinput=$(xinput list-props $TP_DEVICE | grep "Device Node" | cut -d\" -f2)
echo "TrackPoint is Device $TP_DEVICE ($devinput)"

xinput enable $TP_DEVICE
xinput set-prop $TP_DEVICE "Evdev Wheel Emulation" 1
xinput set-prop $TP_DEVICE "Evdev Wheel Emulation Button" 2
