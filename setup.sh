#!/bin/bash
files=(".zshrc" ".zshenv" ".bashrc" ".bashrc.aliases" ".p10k.zsh" ".gitconfig")
for file in * .[^.]*; do
	if [[ " ${files[*]} " =~ " ${file} " ]]; then
		echo "Symlinking file $PWD/$file"
		ln -nfs $PWD/$file /home/$USER/$file
	fi
done
ln -nfs $PWD/.config/pypoetry/config.toml /home/$USER/.config/pypoetry/config.toml
