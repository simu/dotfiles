#!/bin/bash

which puppet
if [ $? -ne 0 -a ! -e /opt/puppetlabs/bin/puppet ]; then
	wget https://apt.puppetlabs.com/puppet-release-`lsb_release -c -s`.deb -O puppetlabs-release-repo.deb
	sudo dpkg -i puppetlabs-release-repo.deb
	rm puppetlabs-release-repo.deb
	sudo apt update
	sudo apt install puppet-agent
	sudo /opt/puppetlabs/bin/puppet module install  --target-dir=/opt/puppetlabs/puppet/modules --modulepath /etc/puppetlabs/code/modules puppetlabs-vcsrepo
	sudo /opt/puppetlabs/bin/puppet module install --target-dir=/opt/puppetlabs/puppet/modules --modulepath /etc/puppetlabs/code/modules wtanaka-mkdir
fi
sudo apt install git python3-mpd python3-jinja2

mkdir -p $(dirname "$0")/generated
python3 generate_manifest.py
/opt/puppetlabs/bin/puppet apply --test generated/dotfiles.pp
