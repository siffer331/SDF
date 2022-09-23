#!/bin/sh

makeXMonad() {
	echo "Starting xmonad" >> .log
	rm ./backup/xmonad.hs &>/dev/null
	rm ./backup/haskell_20.xpm &>/dev/null
	mkdir -p ~/.xmonad/xpm
	mv ~/.xmonad/xmonad.hs ./backup/ &>/dev/null
	mv ~/.xmonad/haskell_20.xpm ./backup/ &>/dev/null
	ln files/haskell_20.xpm ~/.xmonad/xpm/haskell_20.xpm >> .log
	ln files/xmonad.hs ~/.xmonad/xmonad.hs >> .log
	echo "Finished xmonad" >> .log
}

makeKitty() {
	echo "Starting kitty" >> .log
	rm ./backup/kitty.conf &>/dev/null
	mkdir -p ~/.config/kitty
	mv ~/.config/kitty/kitty.conf ./backup/ &>/dev/null
	ln files/kitty.conf ~/.config/kitty/kitty.conf >> .log
	echo "Finished kitty" >> .log
}

makeNeoVim() {
	echo "Starting neovim" >> .log
	rm ./backup/init.vim &>/dev/null
	mkdir -p ~/.config/nvim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>> .log
	mv ~/.config/nvim/init.vim ./backup/ &>/dev/null
	ln files/init.vim ~/.config/nvim/init.vim >> .log
	echo "Finished neovim" >> .log
}

makeZSH() {
	echo "Starting zsh" >> .log
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
		echo "done"
	fi
	echo "Finished zsh" >> .log
}

makeRofi() {
	echo "Starting rofi" >> .log
	rm ./backup/backup/config.rasi &>/dev/null
	mkdir -p ~/.config/rofi
	mv ~/.config/rofi/config.rasi &>/dev/null
	ln files/config.rasi ~/.config/rofi/config.rasi >> .log
	echo "Finished rofi" >> .log
}

makePicom() {
	echo "Starting picom" >> .log
	rm ./backup/picom.conf &>/dev/null
	mv ~/.config/picom.conf ./backup/ &>/dev/null
	ln files/picom.conf ~/.config/picom.conf >> .log
	echo "Finished picom" >> .log
}

makeZathura() {
	echo "Starting zathura" >> .log
	rm ./backup/backup/zathurarc &>/dev/null
	mkdir -p ~/.config/zathura
	mv ~/.config/zathura/zathurarc &>/dev/null
	ln files/zathurarc ~/.config/zathura/zathurarc >> .log
	echo "Finished zathura" >> .log
}

getInput() {
	echo "Begining" > .log
	mkdir -p backup
	files="$(dialog --checklist 'Dotfiles' 15 10 10 \
		'XMonad'  1 'on' \
		'Kitty'   2 'on' \
		'NeoVim'  3 'on' \
		'Zsh'     4 'on' \
		'Picom'   5 'on' \
		'Rofi'    6 'on' \
		'Zathura' 7 'on' \
		3>&1 1>&2 2>&3 3>&1 )"
	echo $files | grep -q XMonad && makeXMonad
	echo $files | grep -q Kitty && makeKitty
	echo $files | grep -q NeoVim && makeNeoVim
	echo $files | grep -q Zsh && makeZSH
	echo $files | grep -q Picom && makePicom
	echo $files | grep -q Rofi && makeRofi
	echo $files | grep -q Zathura && makeZathura
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
