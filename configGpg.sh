KEY=$(gpg --list-signatures --with-colons | grep 'sig' | grep 'Tony Benoy' | head -n 1 | cut -d':' -f5)
echo $KEY
sed -i "s/C26752B6501EAD3D/$KEY/g" $PWD/.gitconfig
