#!/usr/bin/zsh

CWD=`pwd`

echo "Checking ~/bin"
cd ~/bin
git status
echo

echo "Checking ~/dotfiles"
cd ~/dotfiles
git status
echo

echo "Checking ~/dotfiles_local"
cd ~/dotfiles_local
git status
echo

echo "Checking ~/keys"
cd ~/keys
git status
echo

cd $CWD
