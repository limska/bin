#!/usr/bin/zsh

CWD=`pwd`

cd

if [ ! -d ~/bin ] ; then
    echo "Cloning ~/bin"
    git clone git@github.com:limska/bin.git
    cd bin
    git config user.email "6360269+limska@users.noreply.github.com"
    cd ..
    echo
fi

if [ ! -d ~/dotfiles ] ; then
    echo "Cloning ~/dotfiles"
    git clone git@github.com:limska/dotfiles.git
    cd dotfiles
    git config user.email "6360269+limska@users.noreply.github.com"
    cd ..
    echo
fi

if [ ! -d ~/dotfiles_local ] ; then
    echo "Cloning ~/dotfiles_local"
    git clone git@github.com:limska/dotfiles_local.git
    cd dotfiles_local
    git config user.email "6360269+limska@users.noreply.github.com"
    cd ..
    echo
fi

cd $CWD
