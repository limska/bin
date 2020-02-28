#!/usr/bin/zsh

CWD=`pwd`

cd

echo "Cloning ~/bin"
if [ ! -d ~/bin ] ; then
    git clone git@github.com:limska/bin.git
fi
echo

echo "Cloning ~/dotfiles"
if [ ! -d ~/dotfiles ] ; then
    git clone git@github.com:limska/dotfiles.git
fi
echo

echo "Cloning ~/dotfiles_local"
if [ ! -d ~/dotfiles_local ] ; then
    git clone git@github.com:limska/dotfiles_local.git
fi
echo

cd $CWD
