# The following lines were added by compinstall
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

typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Delete]=${terminfo[kdch1]}
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char

setopt prompt_subst
source ~/.zsh/git-prompt/zshrc.sh
source ~/.zsh/functions/*
export PROMPT='[%T] %{$fg_bold[green]%}%2~%{$reset_color%} $(git_super_status)$ '
export RPROMPT='%{$fg_bold[red]%}|%m|%{$reset_color%}'
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export EDITOR=vim
export PERSONAL_SCRIPTS=~/.scripts
export PATH=$PATH:$PERSONAL_SCRIPTS
source "$HOME/.profile"

#ssh-add 2> /dev/null

alias ls='ls --color'
alias l='ls -Alhk'
alias open="xdg-open"
# git but with some extra features
alias g="git"
alias install="sudo apt install"
alias remove="sudo apt-get remove"
alias upgrade="sudo apt-get upgrade"
alias dupgrade="sudo apt-get dist-upgrade"
alias update="sudo apt-get update"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias targz="tar -xvzf"
alias tarbz2="tar -xvjf"
alias diskusage="df -h"
alias copypasta="xclip -sel clip <"
alias cm="setxkbmap us -variant colemak"
alias qw="setxkbmap us"
if [ -f ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
fi

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
