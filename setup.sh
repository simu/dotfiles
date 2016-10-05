#!/bin/bash

which puppet
if [ $? -ne 0 -o ! -e /opt/puppetlabs/bin/puppet ]; then
	wget https://apt.puppetlabs.com/puppetlabs-release-pc1-`lsb_release -c -s`.deb -O puppetlabs-release-repo.deb
	sudo dpkg -i puppetlabs-release-repo.deb
	sudo apt update
	sudo apt install puppet-agent
fi
sudo apt install git python-mpd python-jinja2

python generate_manifest.py
/opt/puppetlabs/bin/puppet apply --test dotfiles.pp
