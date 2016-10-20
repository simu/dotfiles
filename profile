# .profile

DOTFILES=~/.dotfiles/bash

# start dbus if it's not running yet (see
# https://bbs.archlinux.org/viewtopic.php?id=45553)
#if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
#	eval `dbus-launch --sh-syntax --exit-with-session`
#fi

if [ -n "$DESKTOP_SESSION" ]; then
	echo "Connecting to gnome-keyring-daemon"
	eval $(gnome-keyring-daemon -s)
	export SSH_AUTH_SOCK
fi

[[ -f $DOTFILES/path ]] && . $DOTFILES/path

export PATH="$HOME/.cargo/bin:$PATH"
