#!/bin/sh

makeXMonad() {
	mkdir -p ~/.xmonad
	mv ~/.xmonad/xmonad.hs ./backup/ &>/dev/null
	ln files/xmonad.hs ~/.xmonad/xmonad.hs
	xmonad --recompile &>/dev/null
}

makeKitty() {
	mkdir -p ~/.config/kitty
	mv ~/.config/kitty/kitty.conf ./backup/ &>/dev/null
	ln files/kitty.conf ~/.config/kitty/kitty.conf
}

makeNeoVim() {
	mkdir -p ~/.config/nvim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null
	mv ~/.config/nvim/init.vim ./backup/ &>/dev/null
	ln files/init.vim ~/.config/nvim/init.vim
}

makeZSH() {
	mv ~/.zshrc ./backup/ &>/dev/null
	ln files/.zshrc ~/.zshrc
}

makePicom() {
	mv ~/.config/picom.conf ./backup/ &>/dev/null
	ln files/picom.conf ~/.config/picom.conf
}

getInput() {
	mkdir -p backup
	rm backup/*
	rm backup/.*
	files="$(dialog --checklist 'Dotfiles' 15 10 10 \
		'XMonad' 1 'on' \
		'Kitty'  2 'on' \
		'NeoVim' 3 'on' \
		'Zsh'    4 'on' \
		'Picom'  5 'on' \
		3>&1 1>&2 2>&3 3>&1 )"
	clear
	if echo $files | grep XMonad &>/dev/null
	then
		makeXMonad
	fi
	if echo $files | grep Kitty &>/dev/null
	then
		makeKitty
	fi
	if echo $files | grep NeoVim &>/dev/null
	then
		makeNeoVim
	fi
	if echo $files | grep Zsh&>/dev/null
	then
		makeZSH
	fi
	if echo $files | grep Picom &>/dev/null
	then
		makePicom
	fi
}

main() {
	if cat files/kitty.conf &>/dev/null
	then
		getInput
		echo "Dotfiles succesfully linked"
	else
		echo "Not in the repo dotfile folder"
		exit 1
	fi
}
main
