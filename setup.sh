#!/bin/bash
set -euo pipefail

# Symlinked straight into $HOME
files=(".zshrc" ".zshenv" ".bashrc" ".bashrc.aliases" ".p10k.zsh" ".gitconfig")

# Symlinked to the same relative path under $HOME; parent dirs are created
config_files=(".config/git/ignore")

packages_needed=(
	"zsh"
	"oh-my-zsh-git"
	"zsh-fast-syntax-highlighting-git"
	"zsh-autosuggestions-git"
	"zsh-theme-powerlevel10k-git"
	"ttf-meslo-nerd-font-powerlevel10k"
	"eza"
	"bat"
	"fzf"
)

yay -S "${packages_needed[@]}" --noconfirm

link() {
	echo "Symlinking $PWD/$1 -> $HOME/$1"
	mkdir -p "$(dirname "$HOME/$1")"
	ln -nfs "$PWD/$1" "$HOME/$1"
}

for file in "${files[@]}" "${config_files[@]}"; do
	link "$file"
done
