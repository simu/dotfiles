#!/bin/bash

confdir=$(dirname $(readlink -f $0))

echo "config dir: $confdir"

backup_if_exists() {
	# only backup real files / directories
	[ -f ~/.$1  ] && mv ~/.$1 ~/.${1}.orig
	[ -d ~/.$1 -a ! -d ~/.$1.orig ] && mv ~/.$1 ~/.${1}.orig
	# backing up directories slightly trickier when dir.orig already
	# exists
	[ -d ~/.$1 ] && rm ~/.${1}.orig && mv ~/.$1 ~/.${1}.orig
	# just delete existing symlinks
	[ -L ~/.$1 ] && rm ~/.$1
}

install_config() {
	echo "linking $1"
	backup_if_exists $1
	ln -s $confdir/$1 ~/.${1}
}

setup_fonts() {
	install_config "fonts/otf-powerlinesymbols"
	install_config "fonts/ttf-sourcecode"
	mkdir -p ~/.config/fontconfig/conf.d
	powerline_cfg=~/.config/fontconfig/conf.d/10-powerline-symbols.conf
	[ -f $powerline_cfg  ] && mv $powerline_cfg{,.orig}
	[ -L $powerline_cfg  ] && rm $powerline_cfg
	ln -s $confdir/fonts/10-powerline-symbols.conf $powerline_cfg
	echo "updating font cache"
	fc-cache
}

setup_i3wm() {
	mkdir -p ~/.i3/
	backup_if_exists "i3/config"
	echo "linking i3 config"
	ln -s $confdir/i3wm/i3.config ~/.i3/config
	mkdir -p ~/.config/i3status
	echo "linking i3status config"
	backup_if_exists "config/i3status/config"	
	ln -s $confdir/i3wm/i3status.config ~/.config/i3status/config
	echo "installing helpers"
	backup_if_exists "local/bin/i3status-wrapper.py"
	backup_if_exists "local/bin/i3sysctl"
	ln -s $confdir/i3wm/i3status-wrapper.py ~/.local/bin
	ln -s $confdir/i3wm/i3sysctl ~/.local/bin
}

setup_vim() {
	install_config "vimrc"
	echo "linking .vim"
	backup_if_exists "vim"
	mkdir -p ~/.vim
	ln -s $confdir/vim/autoload ~/.vim
	ln -s $confdir/vim/colors ~/.vim
	ln -s $confdir/vim/ftdetect ~/.vim
	ln -s $confdir/vim/ftplugin ~/.vim
	ln -s $confdir/vim/indent ~/.vim
	ln -s $confdir/vim/plugin ~/.vim
	ln -s $confdir/vim/scripts ~/.vim
	ln -s $confdir/vim/spell ~/.vim
	ln -s $confdir/vim/syntax ~/.vim
	ln -s $confdir/vim/vimrc_bundle ~/.vim
	echo " installing Vundle"
	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	echo " running +BundleInstall"
	vim -u ~/.vim/vimrc_bundle +BundleInstall +qa
}

mkdir -p ~/.local/bin

install_config "bash_profile"
install_config "bashrc"
install_config "inputrc"
install_config "gitconfig"
install_config "tmux.conf"

setup_vim

setup_fonts

setup_i3wm
