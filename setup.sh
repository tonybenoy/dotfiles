#!/bin/bash
files=(".zshrc" ".zshenv" ".bashrc" ".bashrc.aliases" ".gitconfig")
for file in * .[^.]*; do 
	if [[ " ${files[*]} " =~ " ${file} " ]]; then
		echo "Symlinking file $PWD/$file"
		ln -nfs $PWD/$file /home/$USER/$file 
	fi
done
