set -o vi
if [ -f ~/.bashrc.aliases ]; then
    source ~/.bashrc.aliases
fi
force_color_prompt=yes
export PATH="/home/tony/.local/bin:$PATH"

