#!/bin/bash

CONFDIR=$(readlink -f "$(dirname "$CRONDIR")")

MANAGED_MARKER="# DO NOT EDIT BELOW: managed by $CONFDIR"

# find managed marker line in $1, return on stdout
function find_marker()  {
	local MANAGED_START
	MANAGED_START=$(grep -n "$MANAGED_MARKER" "$1" | cut -d ':' -f1)
	echo "$MANAGED_START"
}
