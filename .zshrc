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
source ~/.scripts/mancolor.sh
source ~/.zsh/functions/*
export PROMPT='[%T]%{$fg[red]%}%{$fg_bold[green]%} %2~ %{$reset_color%}$(git_super_status)$ '
export PATH=".:/usr/local/bin/:/usr/local/sbin/:$HOME/.cabal/bin/:$PATH"
export EDITOR=vim

alias ls='ls --color'
alias l='ls -Alhk'
alias open="xdg-open"
alias g="git"
alias install="pacaur -S"
alias remove="pacaur -Rsn"
alias upgrade="pacaur -Syu"
alias update="pacaur -Sy"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias targz="tar -xvzf"
alias diskusage="df -h"
alias copypasta="xclip -sel clip <"
