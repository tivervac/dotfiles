#!/bin/sh
echo "Setting permissions..."
chmod -R 700 *

echo "Copying files..."
cp -R .scripts ~
cp -R .zsh ~
cp -R .wallpaper ~
# The GTK theme
cp -R +1 /usr/share/themes
# Shutdown the nvidia card properly
cp nvidia-enable.service /etc/systemd/system
systemctl enable nvidia-enable.service
systemctl start nvidia-enable.service

echo "Creating links..."
cp .gitconfig ~
cp .vimrc ~
cp .zshrc ~
cp .xinitrc ~
cp .Xresources ~
cp i3status.conf /etc/

echo "Setting up Vundle..."
if [[ ! -d ~/.vim/bundle/vundle ]]; then
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

echo "Setting up vim environment..."
mkdir ~/.vim/tmp
mkdir ~/.vim/tmp/swap
mkdir ~/.vim/tmp/backup
vim +BundleInstall! +qall
