# .bash_profile

DOTFILES=~/.dotfiles/bash

# source generic .profile
. ~/.profile

export ORIGPATH=$PATH

[[ -f $DOTFILES/path ]] && . $DOTFILES/path

# Get the aliases and functions
if [ -f ~/.dotfiles/bashrc ]; then
	. ~/.dotfiles/bashrc
elif [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

[[ -f $DOTFILES/environment ]] && . $DOTFILES/environment

# user specific functions
[[ -f $DOTFILES/functions ]] && . $DOTFILES/functions

export PATH
unset USERNAME

