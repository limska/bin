#!/usr/bin/zsh

CWD=`pwd`

echo "Checking ~/bin"
cd ~/bin
git pull -p
git status
echo

echo "Checking ~/dotfiles"
cd ~/dotfiles
git pull -p
git status
echo

echo "Checking ~/dotfiles_local"
cd ~/dotfiles_local
git pull -p
git status
echo

echo "Checking ~/keys"
cd ~/keys
git pull -p
git status
echo

cd $CWD
