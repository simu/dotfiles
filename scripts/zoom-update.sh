#!/bin/bash

readonly deb_url="https://zoom.us/client/latest/zoom_amd64.deb"

readonly inst_ver="$(dpkg -s zoom | grep "^Version:" | cut -d: -f2 | tr -d " ")"

curl -L -o/tmp/zoom.deb "$deb_url" 2>/dev/null

readonly new_ver="$(dpkg -I /tmp/zoom.deb | grep "^ Version:" | cut -d: -f2 | tr -d " ")"

if [[ "$inst_ver" != "$new_ver" ]]; then
  echo "Updating Zoom from $inst_ver to $new_ver"
  gdebi -n /tmp/zoom.deb
else
  echo "Zoom already up-to-date: $inst_ver"
fi
