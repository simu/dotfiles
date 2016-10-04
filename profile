# .profile

DOTFILES=~/.dotfiles/bash

if [ -n "$DESKTOP_SESSION" ]; then
	export $(gnome-keyring-daemon -s)
fi

[[ -f $DOTFILES/path ]] && . $DOTFILES/path

export PATH="$HOME/.cargo/bin:$PATH"
