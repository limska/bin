#!/usr/bin/bash

CWD=$(pwd)

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
  git_folder=$folder/.git
  if [ -d "$git_folder" ] ; then
    branch_name=$(git -C $folder rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo "$folder: branch $(tput setaf 6)$branch_name$(tput sgr0)"
    cd $folder
    git pull -p
    git status --short
    echo
  fi
done

cd $CWD
