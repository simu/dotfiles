#!/bin/bash

CRONDIR=`dirname $0`

CUR_CRONTAB=`mktemp /tmp/crontab_XXXXXX`

# get current crontab
crontab -l > $CUR_CRONTAB

# merge in all crontab snippets
for f in $CRONDIR/$HOSTNAME.d/*; do
    DIFF=`diff -u $CUR_CRONTAB $f | grep "^+[^+]" | cut -c2-`
    echo "$DIFF" >> $CUR_CRONTAB
done

# install merged crontab
crontab $CUR_CRONTAB

# delete temp file
rm $CUR_CRONTAB
