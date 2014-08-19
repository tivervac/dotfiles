#!/bin/sh
echo "Setting permissions..."
chmod -R 700 *

echo "Copying files..."
cp -R .scripts ~
cp -R .zsh ~

echo "Creating links..."
ln -s .gitconfig ~
ln -s .vimrc ~
ln -s .zshrc ~

echo "Setting up vim environment..."
mkdir ~/.vim
mkdir ~/.vim/tmp
mkdir ~/.vim/tmp/swap
mkdir ~/.vim/tmp/backup
vim +BundleInstall! +qall
