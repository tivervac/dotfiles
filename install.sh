#!/bin/sh
echo "Setting permissions..."
chmod -R 700 *

echo "Copying files..."
cp -R .scripts ~
cp -R .zsh ~

echo "Creating links..."
cp .gitconfig ~
cp .vimrc ~
cp .zshrc ~
cp .xinitrc ~
cp .Xresources ~

echo "Setting up vim environment..."
mkdir ~/.vim
mkdir ~/.vim/tmp
mkdir ~/.vim/tmp/swap
mkdir ~/.vim/tmp/backup
vim +BundleInstall! +qall
