#!/bin/bash
# Restore .gitconfig's signingkey to the committed default, undoing configGpg.sh.
set -euo pipefail

KEY=$(gpg --list-signatures --with-colons | grep 'sig' | grep 'Tony Benoy' | head -n 1 | cut -d':' -f5)
if [[ -z $KEY ]]; then
	echo "No GPG signature found for 'Tony Benoy' — nothing to reset." >&2
	exit 1
fi
echo "$KEY"
sed -i "s/$KEY/C26752B6501EAD3D/g" "$PWD/.gitconfig"
