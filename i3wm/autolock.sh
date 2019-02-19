#!/bin/bash

# immediately activate and lock screensaver
~/.local/bin/lock

# after 30 minutes of inactivity, send system to sleep
sleep 30m
~/.local/bin/i3sysctl suspend
