#!/usr/bin/zsh

CWD=`pwd`

cd

if [ ! -d ~/bin ] ; then
    echo "Cloning ~/bin"
    git clone git@github.com:limska/bin.git
    echo
fi

if [ ! -d ~/dotfiles ] ; then
    echo "Cloning ~/dotfiles"
    git clone git@github.com:limska/dotfiles.git
    echo
fi

if [ ! -d ~/dotfiles_local ] ; then
    echo "Cloning ~/dotfiles_local"
    git clone git@github.com:limska/dotfiles_local.git
    echo
fi

cd $CWD
