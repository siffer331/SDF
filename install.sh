#!/bin/sh

makeXMonad() {
	rm ./backup/xmonad.hs &>/dev/null
	mkdir -p ~/.xmonad
	mv ~/.xmonad/xmonad.hs ./backup/ &>/dev/null
	ln files/xmonad.hs ~/.xmonad/xmonad.hs >> .log
	xmonad --recompile &>> .log
}

makeKitty() {
	rm ./backup/kitty.conf &>/dev/null
	mkdir -p ~/.config/kitty
	mv ~/.config/kitty/kitty.conf ./backup/ &>/dev/null
	ln files/kitty.conf ~/.config/kitty/kitty.conf >> .log
}

makeNeoVim() {
	rm ./backup/init.vim &>/dev/null
	mkdir -p ~/.config/nvim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>> .log
	mv ~/.config/nvim/init.vim ./backup/ &>/dev/null
	ln files/init.vim ~/.config/nvim/init.vim >> .log
}

makeZSH() {
	rm ./backup/.zshrc &>/dev/null
	mv ~/.zshrc ./backup/ &>/dev/null
	ln files/.zshrc ~/.zshrc >> .log
	if dialog --yesno "Install/update zsh plugins?" 10 31
	then
		echo "test"
		rm -r ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting &>/dev/null
		rm -r ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/z.lua &>/dev/null
		rm -r $ZSH_CUSTOM/plugins/you-should-use &>/dev/null
		git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting &>> .log
		git clone https://github.com/skywind3000/z.lua.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/z.lua &>> .log
		git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use &>> .log
	fi
}

makePicom() {
	rm ./backup/picom.conf &>/dev/null
	mv ~/.config/picom.conf ./backup/ &>/dev/null
	ln files/picom.conf ~/.config/picom.conf >> .log
}

getInput() {
	echo "Begining" > .log
	mkdir -p backup
	files="$(dialog --checklist 'Dotfiles' 15 10 10 \
		'XMonad' 1 'on' \
		'Kitty'  2 'on' \
		'NeoVim' 3 'on' \
		'Zsh'    4 'on' \
		'Picom'  5 'on' \
		3>&1 1>&2 2>&3 3>&1 )"
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
	clear
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
