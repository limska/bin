#!/usr/bin/zsh

CWD=`pwd`

folders=("bin" "dotfiles" "dotfiles_local" "keys" "brrr")
root=$HOME
if [ $# -gt 1 ]; then
  folders=($*)
  root=$(pwd)
fi
echo "folders=$folders"
echo "root=$root"

for f in "${folders[@]}"; do
    folder="$root/$f"
    echo "Checking $folder"
    cd $folder
    git pull -p
    git status
    echo
done

cd $CWD
