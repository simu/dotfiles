#!/bin/bash

CRONDIR=`dirname $0`

# script to figure out if we need to apply crontab stuff
CUR_CRONTAB_CMDS=`crontab -l 2>&1 | grep -v "^#"`
if [ "$CUR_CRONTAB_CMDS" = "no crontab for ${USER}" ]; then
	exit 0
fi

# put sorted list of current cron commands in temp file
TMPFILE=`mktemp "cron_check.XXXXXX"`
echo "$CUR_CRONTAB_CMDS" | sort > $TMPFILE

# concatenate all host cron snippets into 2nd temp file
TMPCRON=`mktemp "custom_cron.XXXXXX"`
for f in $CRONDIR/$HOSTNAME.d/*; do
    grep -v "^#" $f >> $TMPCRON
done

# compare the two
diff $TMPCRON $TMPFILE 2>&1 >/dev/null
# negate diff retval -- no differences (retval 0) means we don't need to do anything
STATE=`test $? -ne 0; echo $?`

# delete tempfiles
rm $TMPFILE
rm $TMPCRON

exit $STATE
