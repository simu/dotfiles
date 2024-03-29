# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# note to self: pgup, pgdn for search in ~/.inputrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=5000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# configure for 256 colors
case "$TERM" in
    linux*) ;;
    *-256color) ;;
    *-color) TERM="${TERM//-color}-256color";;
    *) TERM="$TERM-256color";;
esac

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    *color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ -f ~/.local/bash_prompt_config ]; then
    . ~/.local/bash_prompt_config
fi

_ps1_kubectx() {
    if [[ x"$KUBECONFIG" != x"" ]]; then
        echo " [$(basename "$KUBECONFIG" | cut -d '.' -f1)]"
    else
        echo ""
    fi
}


if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\D{%Y-%m-%d %H:%m} \[\033[01;10m\]\u@\h\[\033[00m\]:\w \$ '
    if [[ x"$HOSTNAME_COLOR" == x"" ]]; then
        HOSTNAME_COLOR=36
    fi
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;${HOSTNAME_COLOR}m\]\u@\h\[\033[00m\]:\w$(_ps1_kubectx) \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w"'$(_ps1_kubectx)'"\a\]$PS1"
    ;;
screen*|tmux*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w"'$(_ps1_kubectx)'"\a\]$PS1"
    PROMPT_COMMAND='SHORT_PWD=${PWD/\/local2\/gerbesim/l2~};SHORT_PWD=${SHORT_PWD/\/local\/gerbesim/l~};SHORT_PWD=${SHORT_PWD/$HOME/\~};echo -ne "\033k$SHORT_PWD\033\\"' ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

[ -f ~/.dotfiles/bash/aliases ] && . ~/.dotfiles/bash/aliases

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    LS_COLORS=$LS_COLORS'*.ogm=01;35:'
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# for use in scripts -- simon, 2008-11-12
export COLUMNS
export HOSTNAME

#set viewer for texdoc
export TEXDOCVIEW_pdf="evince %s"

# set TERM
#if [ "$COLORTERM" == "gnome-terminal" ]; then
#	export TERM=xterm-256color
#fi

# vi mode
set -o vi

# use liquid prompt: github.com/nojhan/liquidprompt
#source ~/tools/liquidprompt/liquidprompt
