#!/bin/bash
# script to figure out if we need to apply crontab stuff
# if this script exits with 0 the updater is run

CRONDIR=$(dirname "$0")

. "$CRONDIR"/common.sh

TMPFILE=$(mktemp "/tmp/cron_check.XXXXXX")
crontab -l > "$TMPFILE"
MARKERLINE=$(find_marker "$TMPFILE")

# if no commands in crontab; always run updater
CUR_CRONTAB_CMDS=$(tail -n+$((MARKERLINE)) "$TMPFILE" | grep -v "^#")
if [ "$CUR_CRONTAB_CMDS" = "no crontab for ${USER}" ]; then
	exit 0
fi

# put sorted list of current cron commands in temp file
echo "$CUR_CRONTAB_CMDS" | grep -v "^$" | sort > "$TMPFILE"

# concatenate all host cron snippets into 2nd temp file
TMPCRON=$(mktemp "/tmp/custom_cron.XXXXXX")
for f in $CRONDIR/$HOSTNAME.d/*; do
    grep -v "^#" "$f" >> "$TMPCRON"
done

# compare the two
diff "$TMPCRON" "$TMPFILE" >/dev/null 2>&1
# negate diff retval -- no differences (retval 0) means we don't need to do anything
STATE=$(test $? -ne 0; echo $?)

# delete tempfiles
rm "$TMPFILE" "$TMPCRON"

exit "$STATE"
