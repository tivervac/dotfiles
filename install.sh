#!/bin/sh
echo "Setting permissions..."
chmod -R 700 *

echo "Copying files..."
cp -R .scripts ~
cp -R .zsh ~
cp -R .wallpaper ~
cp -R .i3 ~

# The GTK theme
sudo cp -R +1 /usr/share/themes/

# Shutdown the nvidia card properly
sudo cp nvidia-enable.service /etc/systemd/system/
sudo systemctl enable nvidia-enable.service

# Pretty pacman
cp pacman.conf /etc/
cp xorg.cong /etc/X11/

echo "Creating links..."
cp .gitconfig ~
cp .vimrc ~
cp .zshrc ~
cp .xinitrc ~
cp .Xresources ~
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
