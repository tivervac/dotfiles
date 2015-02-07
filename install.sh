#!/bin/sh

set -e

SRC=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Setting permissions..."
chmod -R 700 *

echo "Copying files..."
ln -s "$SRC/.scripts" "$HOME"
cp -R .zsh ~
cp -R .wallpaper ~
ln -s "$SRC/.i3" "$HOME"

# The GTK theme
sudo cp -R +1 /usr/share/themes/

# Shutdown the nvidia card properly
sudo cp nvidia-enable.service /etc/systemd/system/
sudo systemctl enable nvidia-enable.service

# Pretty pacman
cp pacman.conf /etc/
cp xorg.cong /etc/X11/

echo "Creating links..."
ln -s "$SRC/.gitconfig" "$HOME"
ln -s "$SRC/.vimrc" "$HOME"
ln -s "$SRC/.zshrc" "$HOME"
ln -s "$SRC/.xinitrc" "$HOME"
ln -s "$SRC/.Xresources" "$HOME"
sudo cp slim.conf /etc/
sudo cp clipboard /usr/lib/urxvt/perl/clipboard

mkdir ~/Pictures

echo "Setting up Vundle..."
if [[ ! -d ~/.vim/bundle/vundle ]]; then
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

echo "Setting up vim environment..."
mkdir ~/.vim/tmp
mkdir ~/.vim/tmp/swap
mkdir ~/.vim/tmp/backup
vim +BundleInstall! +qall
