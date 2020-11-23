#!/bin/bash

set -x

CRONDIR=$(dirname "$0")
. "$CRONDIR"/common.sh

CUR_CRONTAB=$(mktemp /tmp/cur_crontab_XXXXXX)
NEW_CRONTAB=$(mktemp /tmp/new_crontab_XXXXXX)

# get current crontab
crontab -l > "$CUR_CRONTAB"

MANAGED_START=$(find_marker "$CUR_CRONTAB")

# put unmanaged part back into new crontab
head -n $((MANAGED_START-1)) "$CUR_CRONTAB" > "$NEW_CRONTAB"

# emit management marker line
echo "$MANAGED_MARKER" >> "$NEW_CRONTAB"
# merge in all crontab snippets
for f in $CRONDIR/$HOSTNAME.d/*; do
	echo -e "\n# from $f" >> "$NEW_CRONTAB"
	cat "$f" >> "$NEW_CRONTAB"
done

# install merged crontab
crontab "$NEW_CRONTAB"

if [ $? -eq 0 ]; then
# delete temp file
rm "$CUR_CRONTAB" "$NEW_CRONTAB"
fi
