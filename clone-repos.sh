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

if [ ! -d ~/keys ] ; then
    echo "Cloning ~/keys"
    #git clone git@gitlab.cloudnc.in:sava.slijepcevic/keys.git
    git clone git@gitlab.com:limska/keys.git
    chmod 700 keys
    echo
fi

cd $CWD
