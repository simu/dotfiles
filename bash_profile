# .bash_profile

export ORIGPATH=$PATH

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

[[ -f ~/.bash/environment ]] && . ~/.bash/environment

# user specific functions
[[ -f ~/.bash/functions ]] && . ~/.bash/functions

export PATH
unset USERNAME

