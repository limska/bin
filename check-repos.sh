#!/usr/bin/zsh

CWD=`pwd`

cd ~/bin
git status

cd ~/dotfiles
git status

cd ~/dotfiles_local
git status

cd $CWD
