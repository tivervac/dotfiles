#!/bin/bash

set -ue
USAGE="Usage: "$0": --[all|arch|bb|gui|i3|no-gui|vim|ntp]"
if [ $# -ne 1 ]; then
    echo $USAGE
    exit 1;
fi

SRC=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Setting permissions..."
chmod -R 700 "$SRC"

function setup_arch() {
    echo "Setting up arch..."
    # Pretty pacman
    sudo cp pacman.conf /etc/
}

function setup_gradle() {
    ln -sfn "$SRC/.gradle" "$HOME"
}

function setup_ntp() {
    sudo cp ntp.conf /etc/
    sudo systemctl enable ntpd.service
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
    mkdir -p "$HOME/.config"
    ln -sfn "$SRC/.config/htop" "$HOME/.config/"
    ln -sfn "$SRC/.config/ranger" "$HOME/.config/"
    setup_vim
}

function setup_ssh_agent() {
    ln -sfn "$SRC/.config/systemd/" "$HOME/.config/"
    # No quotes for expansion :)
    sudo cp $SRC/dbus.{socket,service} "/etc/systemd/user/"
    sudo mkdir -p "/etc/systemd/system/user@.service.d"
    sudo cp "$SRC/dbus.conf" "/etc/systemd/system/user@.service.d/"
    sudo systemctl --global enable dbus.socket
    systemctl --user enable ssh-agent.service
}

function setup_i3() {
    echo "Setting up i3..."
    cp -R "$SRC/.wallpaper" "$HOME"
    mkdir -p "$HOME/.i3"

    cp "$SRC/.i3/config" "$HOME/.i3/config"
    cp "$SRC/.i3/i3status.conf" "$HOME/.i3/i3status.conf"
    cp "$SRC/.Xresources" "$HOME/.Xresources"
    ln -sfn "$SRC/.xinitrc" "$HOME"
    sudo cp "$SRC/clipboard" /usr/lib/urxvt/perl/clipboard
    sudo cp "$SRC/font-size" /usr/lib/urxvt/perl/font-size
}

function setup_gui() {
    setup_i3
    echo "Setting up rest of GUI..."
    sudo systemctl enable slim.service
    sudo cp "$SRC/slim.conf" /etc/
    sudo cp "$SRC/xorg.conf" /etc/X11/
    # Configure compton
    cp "$SRC/.compton.conf" "$HOME"
    # Configure dunst
    ln -sfn "$SRC/.config/dunst" "$HOME/.config/dunst"
}

for OPT in $*; do
    case "$OPT" in
        --all)          setup_gui
                        setup_non_gui
                        setup_arch
                        setup_ntp
                        setup_gradle
                        setup_ssh_agent;;
        --arch)         setup_arch;;
        --bb)           setup_bumblee;;
        --gui)          setup_gui;;
        --gradle)       setup_gradle;;
        --i3)           setup_i3;;
        --ssh-agent)    setup_ssh_agent;;
        --no-gui)        setup_non_gui;;
        --vim)          setup_vim;;
        --ntp)          setup_ntp;;
        *)              echo $USAGE
                        exit 2;;
    esac
done
