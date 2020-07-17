#!/bin/bash

set -eo pipefail

echo "Reading Nvidia temp"
readonly temp=$(nvidia-smi -q -d TEMPERATURE | awk '/GPU Current/{ print $5 };')

echo "${temp}000" > /tmp/gputemp
