set -o vi
if [ -f ~/.bashrc.aliases ]; then
    source ~/.bashrc.aliases
fi
force_color_prompt=yes

# Prepend only when absent, so re-sourcing this file does not stack duplicates
for dir in "$HOME/.local/bin" "$HOME/.npm-global/bin"; do
	case ":$PATH:" in
		*":$dir:"*) ;;
		*) PATH="$dir:$PATH" ;;
	esac
done
export PATH
