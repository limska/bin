#!/bin/bash

CWD=`pwd`

cd

makelink () {
    target=$1
    if [ ! -f $target ] ; then
        echo "Can not find $target skipping"
        return
    fi
    if [ -n "$2" ] ; then
        base=$2
    else 
        base=`basename $target`
    fi
    if [ -f ~/$base ] ; then
        echo "Link ~/$base found skipping"
    else
        ln -vs $target $base
    fi
}

makelink dotfiles_local/.flexlmrc
makelink dotfiles_local/.gitconfig
makelink dotfiles_local/.tmux.conf.local .tmux.conf
makelink dotfiles_local/.vimrc
makelink dotfiles_local/.zshenv
makelink dotfiles_local/.zshrc
makelink dotfiles_local/.Xresources




cd $CWD
