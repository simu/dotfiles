# .bash_profile

DOTFILES=~/.dotfiles/bash

export ORIGPATH=$PATH

[[ -f ~/.dotfiles/bash/path ]] && . ~/.dotfiles/bash/path

# Get the aliases and functions
if [ -f ~/.dotfiles/bashrc ]; then
	. ~/.dotfiles/bashrc
elif [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

[[ -f ~/.dotfiles/bash/environment ]] && . ~/.dotfiles/bash/environment

# user specific functions
[[ -f ~/.dotfiles/bash/functions ]] && . ~/.dotfiles/bash/functions

export PATH
unset USERNAME

