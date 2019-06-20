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

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Disable Ctrl+S in terminal
stty -ixon

setopt prompt_subst
source ~/.zsh/git-prompt/zshrc.sh
source ~/.zsh/functions/*

export PROMPT='[%T] %{$fg_bold[green]%}%2~%{$reset_color%} $(git_super_status)$ '
export RPROMPT='%{$fg_bold[red]%}|%m|%{$reset_color%}'
export EDITOR=vim
export PERSONAL_SCRIPTS=~/.scripts
export PATH=$PATH:$PERSONAL_SCRIPTS
export CLASSPATH=".:/usr/local/lib/antlr-3.5.2-complete.jar:/usr/local/lib/antlr-4.7-complete.jar:$CLASSPATH"
export CLASSPATH="/usr/lib/jvm/default-runtime/lib/tools.jar:$CLASSPATH"
export _JAVA_AWT_WM_NONREPARENTING=1

alias ls='ls --color'
alias l='ls -Alhk'
alias open="xdg-open"
alias g="git"
alias install="sudo yum install"
alias remove="sudo yum remove"
alias upgrade="sudo yum update"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias untar="tar -xvf"
alias targz="tar -xvzf"
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
alias sgs="cd /home/t21/sigasi-dev/git/sigasi"
alias rm="rm -Iv"
alias rmstalebranches="g branch --merged | grep -v master > /tmp/merged-branches && vim /tmp/merged-branches && xargs git branch -d < /tmp/merged-branches"
alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.7-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias grun='java org.antlr.v4.gui.TestRig'
alias vivado="/home/titouanvervack/Xilinx/Vivado/2017.4/bin/vivado"

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

