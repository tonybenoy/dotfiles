#!/bin/bash
set -euo pipefail

# Symlinked straight into $HOME
files=(".zshrc" ".zshenv" ".bashrc" ".bashrc.aliases" ".p10k.zsh" ".gitconfig")

# Symlinked to the same relative path under $HOME; parent dirs are created
config_files=(".config/git/ignore")

# Debian/Ubuntu: things apt doesn't carry are cloned here; .zshrc looks here too
zsh_share="$HOME/.local/share/zsh"

. /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
*" arch "*) distro=arch ;;
*" debian "* | *" ubuntu "*) distro=debian ;;
*)
	echo "Unsupported distro: ${PRETTY_NAME:-unknown} (need Arch or Debian-based)" >&2
	exit 1
	;;
esac

install_arch() {
	local packages_needed=(
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
}

clone() { # clone <url> <dest>
	if [[ -d $2/.git ]]; then
		git -C "$2" pull --ff-only
	else
		git clone --depth=1 "$1" "$2"
	fi
}

install_debian() {
	sudo apt-get update
	sudo apt-get install -y zsh git curl gnupg fzf bat zsh-autosuggestions fontconfig

	# eza is only in Debian 13+/Ubuntu 24.04+; older releases use the project's apt repo
	if ! apt-cache policy eza | grep -q 'Candidate: [0-9]'; then
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc |
			sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
		echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" |
			sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
		sudo apt-get update
	fi
	sudo apt-get install -y eza

	# Debian ships bat as `batcat`; .zshrc/.bashrc.aliases call `bat`
	mkdir -p "$HOME/.local/bin"
	if ! command -v bat >/dev/null && command -v batcat >/dev/null; then
		ln -nfs "$(command -v batcat)" "$HOME/.local/bin/bat"
	fi

	mkdir -p "$zsh_share"
	clone https://github.com/ohmyzsh/ohmyzsh.git "$zsh_share/oh-my-zsh"
	clone https://github.com/romkatv/powerlevel10k.git "$zsh_share/powerlevel10k"
	clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$zsh_share/fast-syntax-highlighting"

	# MesloLGS NF, the font p10k expects (same files as Arch's ttf-meslo-nerd-font-powerlevel10k)
	local font_dir="$HOME/.local/share/fonts" base=https://github.com/romkatv/powerlevel10k-media/raw/master f
	mkdir -p "$font_dir"
	for f in Regular Bold Italic "Bold Italic"; do
		[[ -f "$font_dir/MesloLGS NF $f.ttf" ]] ||
			curl -fsSL -o "$font_dir/MesloLGS NF $f.ttf" "$base/MesloLGS%20NF%20${f// /%20}.ttf"
	done
	fc-cache -f "$font_dir"
}

"install_$distro"

link() {
	echo "Symlinking $PWD/$1 -> $HOME/$1"
	mkdir -p "$(dirname "$HOME/$1")"
	ln -nfs "$PWD/$1" "$HOME/$1"
}

for file in "${files[@]}" "${config_files[@]}"; do
	link "$file"
done
