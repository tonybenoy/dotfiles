typeset -U path PATH
path=(~/.local/bin $path)
export PATH
# Use gnome-keyring's ssh agent when its socket exists and no agent is set; no-op without GNOME (e.g. WSL/Arch)
[[ -z ${SSH_AUTH_SOCK:-} && -S /run/user/$UID/keyring/ssh ]] && export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
