# .bash_profile

export ORIGPATH=$PATH

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

