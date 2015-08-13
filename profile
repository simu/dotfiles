if [ -n "$DESKTOP_SESSION" ]; then
	export $(gnome-keyring-daemon -s)
fi

[[ -f ~/.dotfiles/bash/path ]] && . ~/.dotfiles/bash/path
