#!/bin/bash

set -ue
if [ $# == 0 ]; then
    printf "Usage: %s: --[all|arch|bb|gui|i3|nogui|vim]\n" $0
    exit 1;
fi

SRC=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Setting permissions..."
sudo chmod -R 700 "$SRC"

function setup_arch() {
    echo "Setting up arch..."
    # Pretty pacman
    cp pacman.conf /etc/
}

function setup_bumblebee() {
    echo "Setting up bumblebee..."
    # Shutdown the nvidia card properly
    sudo cp nvidia-enable.service /etc/systemd/system/
    sudo systemctl enable nvidia-enable.service
}

function setup_vim() {
    echo "Setting up Vundle..."
    mkdir -p "$SRC/.vim/bundle"
    if [[ ! -d "$SRC/.vim/bundle/vundle" ]]; then
        git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    fi

    echo "Setting up vim environment..."
    ln -sfn "$SRC/.vimrc" "$HOME"
    mkdir -p "$HOME/.vim/tmp/swap"
    mkdir "$HOME/.vim/tmp/backup"
    vim +BundleInstall! +qall
}

function setup_non_gui() {
    echo "Setting up non GUI elements..."
    ln -sfn "$SRC/.scripts" "$HOME"
    ln -sfn "$SRC/.gitconfig" "$HOME"
    ln -sfn "$SRC/.zshrc" "$HOME"
    ln -sfn "$SRC/.zsh" "$HOME"
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
    sudo cp "$SRC/slim.conf" /etc/
    cp "$SRC/xorg.conf" /etc/X11/
}

for OPT in $*; do
    case "$OPT" in
        --all)      setup_gui
                    setup_non_gui
                    setup_arch
                    setup_bumblebee;;
        --arch)     setup_arch;;
        --bb)       setup_bumblee;;
        --gui)      setup_gui;;
        --i3)       setup_i3;;
        --nogui)   setup_non_gui;;
        --vim)      setup_vim;;
        *)          printf "Usage: %s: --[all|arch|bb|gui|i3|nogui|vim]\n" $0
                    exit 2;;
    esac
done
