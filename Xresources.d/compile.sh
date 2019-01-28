#!/bin/bash

set -x

DATADIR=`dirname $0`

siteconfig=`find $DATADIR/parts.d -name "${HOSTNAME}.*"`

OUTFILE=$CONFDIR/generated/Xresources

cat $DATADIR/Xresources > $OUTFILE
for f in $siteconfig; do
    cat $f >> $OUTFILE
done
