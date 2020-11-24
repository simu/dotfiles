This is my collection of configuration files. Currently included are my

* bash configuration
* vim configuration
* font configuration necessary for vim-airline to work
* [i3 window manager configuration](i3wm) (+i3status configuration and scripts)
* git configuration
* cronjob configuration
* Xresources configuration

Setup
=====

The `setup.sh` script tries to bootstrap a machine using the dotfiles in this repo.

Some required dependencies (puppet, git, python-mpd, and python-jinja2) are installed, and finally the commands reproduced below are executed.

```bash
mkdir -p `dirname $0`/generated && \
python generate_manifest.py && \
/opt/puppetlabs/bin/puppet apply --test generated/dotfiles.pp
```

License
=======

* Configurations are licensed under MIT license, see LICENSE
* Adobe Source Code Pro ([fonts/ttf-sourcecode](fonts/ttf-sourcecode)) is licensed under OFL 1.1 (see corresponding [LICENSE.md](fonts/ttf-sourcecode/LICENSE.md)).
* Adobe Source Sans Pro ([fonts/ttf-sourcesans](fonts/ttf-sourcesans)) is licensed under OFL 1.1 (see corresponding [LICENSE.md](fonts/ttf-sourcesans/LICENSE.md)).
