#!/bin/bash

set -eo pipefail

if [ ! -e /usr/bin/puppet ]; then
	wget "https://apt.puppetlabs.com/puppet8-release-$(lsb_release -c -s).deb" -O puppetlabs-release-repo.deb
	sudo dpkg -i puppetlabs-release-repo.deb
	rm puppetlabs-release-repo.deb
	sudo apt update
	sudo apt install puppet-agent
	modpath=$(puppet config print modulepath|cut -d: -f1)
	sudo puppet module install --target-dir="$modpath" puppetlabs-vcsrepo
	sudo puppet module install --target-dir="$modpath" wtanaka-mkdir
fi
sudo apt install git python3-mpd python3-jinja2 python3-pulsectl

mkdir -p "$(dirname "$0")/generated"
python3 generate_manifest.py
/opt/puppetlabs/bin/puppet apply --test generated/dotfiles.pp
