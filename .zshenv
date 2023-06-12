typeset -U path PATH
path=(~/.local/bin $path)
export PATH
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
