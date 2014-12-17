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
source $HOME/.scripts/mancolor.sh
PROMPT='[%T]%{$fg[red]%}%{$fg_bold[green]%} %2~ %{$reset_color%}$(git_super_status)$ '
export ANDROID_HOME="/usr/local/android-studio/sdk"
export JAVA_HOME="/usr/local/lib/jdk1.8.0_05"
export GENY_HOME="/usr/local/genymotion"
export PATH=".:/usr/local/bin/:/usr/local/sbin/:$HOME/.cabal/bin/:$JAVA_HOME/bin:$GENY_HOME:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

export EDITOR=vim
alias ls='ls --color'

alias l='ls -al'
alias open="xdg-open"
alias g="git"
alias install="sudo pacman -S"
alias remove="sudo pacman -Rsn"
alias upgrade="sudo pacman -Syu"
alias update="sudo pacman -Sy"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias targz="tar -xvzf"
alias geny="sudo $GENY_HOME/genymotion &"
alias diskusage="df -h"
alias hddsleep="sudo hdparm -S 1 /dev/sdb"
alias copypasta="xclip -sel clip <"
