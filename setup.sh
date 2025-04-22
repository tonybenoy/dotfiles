#!/bin/bash
files=(".zshrc" ".zshenv" ".bashrc" ".bashrc.aliases" ".p10k.zsh" ".gitconfig")
packages_needed=("zsh-fast-syntax-highlighting-git" "zsh-autosuggestions-git" "zsh" "oh-my-zsh-git" "ttf-meslo-nerd-font-powerlevel10k"  "zsh-theme-powerlevel10k-git" "exa" "bat" "fzf")
for pkg in ${packages_needed[@]}; do
	yay -S $pkg --noconfirm
done
for file in * .[^.]*; do
	if [[ " ${files[*]} " =~ " ${file} " ]]; then
		echo "Symlinking file $PWD/$file"
		ln -nfs $PWD/$file /home/$USER/$file
	fi
done
ln -nfs $PWD/.config/pypoetry/config.toml /home/$USER/.config/pypoetry/config.toml
