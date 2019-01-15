#!/bin/sh
ps -u simon | grep mate-session 2>&1 >/dev/null
if [ $? -eq 0 ]; then
	mate-session-save --logout
else
	i3-msg exit
fi
