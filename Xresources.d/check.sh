#!/bin/bash

set -x

DATADIR=`dirname $0`

siteconfig=`find $DATADIR/parts.d -name "${HOSTNAME}.*"`

LIVEFILE=$CONFDIR/generated/Xresources
TEMPFILE=`mktemp Xresources.XXXXXX`

cat $DATADIR/Xresources > $TEMPFILE
for f in $siteconfig; do
    cat $f >> $TEMPFILE
done

diff -du $LIVEFILE $TEMPFILE

STATUS=`test $? -ne 0; echo $?`

rm $TEMPFILE

exit $STATUS
