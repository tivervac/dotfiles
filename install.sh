#!/bin/bash

set -ue
USAGE="Usage: "$0": --[all|arch|bb|gui|i3|nogui|vim|ntp]"
if [ $# == 0 ]; then
    echo $USAGE
    exit 1;
fi

SRC=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Setting permissions..."
sudo chmod -R 700 "$SRC"

function setup_arch() {
    echo "Setting up arch..."
    # Pretty pacman
    sudo cp pacman.conf /etc/
}

function setup_ntp() {
    sudo cp ntp.conf /etc/
    sudo systemctl enable ntpd.service
}

function setup_bumblebee() {
    echo "Setting up bumblebee..."
    # Disable nouveau
    sudo cp blacklist.conf /etc/modprobe.d
    # Shutdown the nvidia card properly
    sudo cp nvidia-enable.service /etc/systemd/system/
    sudo systemctl enable nvidia-enable.service
}

function setup_vim() {
    echo "Setting up Vundle..."
    mkdir -p "$HOME/.vim/bundle"
    if [[ ! -d "$HOME/.vim/bundle/vundle" ]]; then
        git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
        vim +BundleInstall! +qall
    fi

    echo "Setting up vim environment..."
    ln -sfn "$SRC/.vimrc" "$HOME"
    mkdir -p "$HOME/.vim/tmp/swap"
    mkdir -p "$HOME/.vim/tmp/backup"
}

function setup_non_gui() {
    echo "Setting up non GUI elements..."
    ln -sfn "$SRC/.scripts" "$HOME"
    ln -sfn "$SRC/.gitconfig" "$HOME"
    ln -sfn "$SRC/.zshrc" "$HOME"
    ln -sfn "$SRC/.zsh" "$HOME"
    mkdir -p "$HOME/.config/htop/"
    ln -sfn "$SRC/htoprc" "$HOME/.config/htop/"
    setup_vim
}

function setup_i3() {
    echo "Setting up i3..."
    cp -R "$SRC/.wallpaper" "$HOME"
    ln -sfn "$SRC/.i3" "$HOME"
    ln -sfn "$SRC/.xinitrc" "$HOME"
    ln -sfn "$SRC/.Xresources" "$HOME"
    sudo cp "$SRC/clipboard" /usr/lib/urxvt/perl/clipboard
}

function setup_gui() {
    setup_i3
    echo "Setting up rest of GUI..."
    # The GTK theme
    sudo cp -R "$SRC/gtk-theme" /usr/share/themes/
    sudo chmod -R 755 /usr/share/themes/
    sudo systemctl enable slim.service
    sudo cp "$SRC/slim.conf" /etc/
    sudo cp "$SRC/xorg.conf" /etc/X11/
}

for OPT in $*; do
    case "$OPT" in
        --all)      setup_gui
                    setup_non_gui
                    setup_arch
                    setup_bumblebee
                    setup_ntp;;
        --arch)     setup_arch;;
        --bb)       setup_bumblee;;
        --gui)      setup_gui;;
        --i3)       setup_i3;;
        --nogui)    setup_non_gui;;
        --vim)      setup_vim;;
        --ntp)      setup_ntp;;
        *)          echo $USAGE
                    exit 2;;
    esac
done
