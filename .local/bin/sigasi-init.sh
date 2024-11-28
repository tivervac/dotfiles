#!/bin/sh

export PATH="$PATH":"$HOME"/.m2/smtools-linux-x64/
export SM_HOST="https://clientauth.one.digicert.com"
export SM_CLIENT_CERT_FILE="${HOME}/.m2/Sigasi_EV_Code_Signing_Certificate.p12"
export SM_HOST=https://clientauth.one.digicert.com
export QSYS_ROOTDIR="/home/t21/intelFPGA_cte/23.1std/quartus/sopc_builder/bin"

alias sgs='cd $HOME/sigasi-dev/git/sigasi'
alias sgdos='cd $HOME/sigasi-dos/git/sigasi'
alias sgtres='cd $HOME/sigasi-tres/git/sigasi'
alias dockerlogin="aws ecr get-login-password | docker login --username AWS --password-stdin 906120494814.dkr.ecr.eu-west-1.amazonaws.com"
