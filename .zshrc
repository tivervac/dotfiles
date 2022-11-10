# The following lines were added by compinstall
FPATH=$FPATH:/usr/share/zsh/5.8.1/functions
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
export LANG='en_US.UTF-8'

autoload colors
colors

source ~/.profile

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# Disable Ctrl+S in terminal
stty -ixon

setopt prompt_subst
eval "$(starship init zsh)"
source ~/.zsh/functions/*

export EDITOR=vim
export PERSONAL_SCRIPTS=~/.scripts
export JAVA_HOME="/home/t21/jdk/graal11"
export PATH=$PATH:$PERSONAL_SCRIPTS:$JAVA_HOME/bin/
export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH=$PATH:$NPM_PACKAGES
export PATH=$PATH:/home/t21/.local/bin
export _JAVA_AWT_WM_NONREPARENTING=1
export PATH=$PATH:$JAVA_HOME/bin

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

alias ls='ls --color'
alias l='ls -Alhk'
alias open="xdg-open"
alias g="git"
alias install="sudo dnf install"
alias remove="sudo dnf remove"
alias rust-update="rustup update"
alias cargo-update="cargo install-update -a"
alias snap-update="snap refresh"
alias upgrade="sudo snap refresh; yarn global upgrade; flatpak update; sudo dnf update; rust-update; cargo-update"
alias update="upgrade"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias untar="tar -xvf"
alias targz="tar -xvzf"
alias targzlist="tar -ztvf"
alias targzlistshort="tar --exclude='*/*' -ztvf"
alias tarbz2="tar -xvjf"
alias diskusage="df -h"
alias copypasta="xclip -sel clip <"
alias cm="setxkbmap us -variant colemak"
alias qw="setxkbmap us"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias sgs="cd /home/t21/sigasi-dev/git/sigasi"
alias sgdos="cd /home/t21/sigasi-dos/git/sigasi"
alias rm="rm -Iv"
alias rmstalebranches="g branch --merged | grep -v master > /tmp/merged-branches && vim /tmp/merged-branches && xargs git branch -d < /tmp/merged-branches"
alias sgtres="cd /home/t21/sigasi-tres/git/sigasi"
alias notes="cd /home/t21/git/knowledge-base"
alias rm="rm -Iv"
alias rmstalebranches="g branch --merged | grep -v master > /tmp/merged-branches && vim /tmp/merged-branches && xargs git branch -d < /tmp/merged-branches"
alias lg="lazygit"

function rmremotebranch () {
    read "?Are you sure you want to remove the REMOTE branch: $fg_bold[red]"$*"$reset_color? [yY]"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        git push origin :$*
        echo "Removed remote branch "$*
    else
        echo "Canceled removal..."
    fi
}

function o () {
    open "$*" &|
}

function proxy () {
    /usr/local/bin/sshuttle -r $1 --dns 0/0
}

eval "$(starship init zsh)"

source ~/.scripts/mancolor.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
