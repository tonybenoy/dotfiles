#!/bin/bash
# Point .gitconfig's signingkey at the GPG key on this machine.
set -euo pipefail

KEY=$(gpg --list-signatures --with-colons | grep 'sig' | grep 'Tony Benoy' | head -n 1 | cut -d':' -f5)
if [[ -z $KEY ]]; then
	echo "No GPG signature found for 'Tony Benoy' — refusing to blank out signingkey." >&2
	exit 1
fi
echo "$KEY"
sed -i "s/C26752B6501EAD3D/$KEY/g" "$PWD/.gitconfig"
