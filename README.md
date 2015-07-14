This is my collection of configuration files. Currently included are my

* bash configuration
* vim configuration
* font configuration necessary for vim-airline to work
* [i3 window manager configuration](i3wm) (+i3status configuration and scripts)
* git configuration

Setup
=====

The `setup.sh` script tries to symlink the various config files to the right
locations in your home directory.  This is tested only for a setup where the
checkout of this repository is in `~/.dotfiles`. Note that that path is
hardcoded in some of the configs as well.

This should work
```
$ cd ~
$ git clone https://github.com/simu/dotfiles.git .dotfiles
$ .dotfiles/setup.sh
```


License
=======

* Configurations are licensed under MIT license, see LICENSE
* Adobe Source Code Pro fonts ([fonts/ttf-sourcecode](fonts/ttf-sourcecode)) are licensed under OFL
  1.1 (see corresponding [LICENSE.txt](fonts/ttf-sourcecode/LICENSE.txt)).
