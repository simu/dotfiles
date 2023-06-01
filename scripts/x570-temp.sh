#!/bin/bash

set -eo pipefail

echo "Reading Ryzen/X570 temp"
readonly temp=$(sensors -j | jq -r '."nct6798-isa-0290".SYSTIN.temp1_input * 1000')
readonly liquid_temp=$(echo "$(liquidctl status --match 'H100i' | grep 'Liquid temperature' | tr -s ' ' | cut -d' ' -f4) * 1000" | bc | cut -d. -f1)

echo "${temp}" > /tmp/cputemp
echo "${liquid_temp}" > /tmp/liquidtemp
