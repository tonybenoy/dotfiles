# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# Arch installs these under /usr/share; setup.sh on Debian clones them to ~/.local/share/zsh
_zsh_first() { local f; for f in "$@"; do [[ -e $f ]] && { print -r -- $f; return; }; done; }
export ZSH=$(_zsh_first /usr/share/oh-my-zsh ~/.local/share/zsh/oh-my-zsh)
source "$(_zsh_first /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme)"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
source "$(_zsh_first /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh)"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages command-not-found cp docker fzf pip rust docker-compose python)

source $ZSH/oh-my-zsh.sh

# These must be sourced after oh-my-zsh
# zsh-autocomplete removed — conflicts with oh-my-zsh's fzf plugin (history-search widget clash)
_fsh=$(_zsh_first /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ~/.local/share/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh)
[[ -n $_fsh ]] && source "$_fsh"
unset _fsh
unfunction _zsh_first

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias ls="eza -la"
alias cat="bat"
# Start gnome-keyring's ssh component if it's installed, we're in a graphical session and no agent is set; no-op on WSL/Arch without GNOME
if [[ -z ${SSH_AUTH_SOCK:-} && -n ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]] && (( $+commands[gnome-keyring-daemon] )); then
  _gk=$(gnome-keyring-daemon --start --components=ssh 2>/dev/null)
  [[ $_gk =~ 'SSH_AUTH_SOCK=([^[:space:]]+)' ]] && export SSH_AUTH_SOCK=$match[1]
  unset _gk
fi
alias startssh="ssh-add $HOME/.ssh/tony"
# GPG signing support: unlock the agent up front with a throwaway signature
alias startgpg='export GPG_TTY=$(tty) && echo "test" | gpg --clearsign'
# WSL only — clip.exe does not exist on native Linux, which has the real xclip
[[ -n ${WSL_DISTRO_NAME:-} ]] && alias xclip="clip.exe <"

# $HOME/.local/bin is already on the path via .zshenv
export PATH="$HOME/.npm-global/bin:$PATH"  # npm --global
export PATH="$HOME/.opencode/bin:$PATH"    # opencode
export PATH="$HOME/.sigyn/bin:$PATH"       # sigyn
