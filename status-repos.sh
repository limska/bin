#!/usr/bin/zsh


CWD=`pwd`

folders=("bin" "dotfiles" "dotfiles_local" "keys")
root=$HOME

for f in "${folders[@]}"; do
    folder="$root/$f"
    echo "Checking $folder"
    cd $folder
    git status
    echo
done

cd $CWD
