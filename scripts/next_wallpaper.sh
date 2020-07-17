#!/bin/bash
export DISPLAY=$1
files=(~/Pictures/wallpapers/*)
WALLPAPER=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER2=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER3=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
if [ -n "$2" ]; then
  echo "[$(date)] Startup mode"
  sleep 2
fi
echo "[$(date)] Changing wallpapers to $WALLPAPER, $WALLPAPER2 $WALLPAPER3"
feh --bg-fill "$WALLPAPER" --bg-fill "$WALLPAPER2" --bg-fill "$WALLPAPER3"

# vim: set et sw=2 ts=2:
