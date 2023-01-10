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
        ls -la $base
    else
        ln -vs $target $base
    fi
}

makelink dotfiles_local/.flexlmrc
makelink dotfiles_local/.gitconfig
makelink dotfiles_local/.tmux.conf.local .tmux.conf
makelink dotfiles_local/.vimrc
makelink dotfiles_local/.zshenv
makelink dotfiles/.zshrc
makelink dotfiles_local/.Xresources

# Install fzf 
echo
echo "Install fzf"
if [ -d ~/.fzf ] ; then
  echo "fzf already installed, skipping"
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

echo
echo "Install oh-my-zsh"
echo "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""

cd $CWD
