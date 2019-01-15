#!/bin/bash
files=(~/Pictures/wallpapers/*)
WALLPAPER=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER2=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
echo "[`date`] Changing wallpapers to $WALLPAPER, $WALLPAPER2" >> /tmp/next_wp.log
feh --bg-fill $WALLPAPER --bg-fill $WALLPAPER2 --bg-fill $WALLPAPER3
