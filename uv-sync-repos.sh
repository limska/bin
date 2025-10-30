#!/usr/bin/bash

CWD=$(pwd)

folders=("*")
workdir=$HOME
if [ $# -gt 1 ]; then
  folders=($*)
  workdir=$(pwd)
fi
echo "folders=$folders"
echo "workdir=$workdir"

for f in "${folders[@]}"; do
  folder="$workdir/$f"
  lockfile="$folder/uv.lock"
  if [ -f "$lockfile" ]; then
    echo "Syncing $folder"
    cd "$folder" || exit
    uv sync --active --inexact --resolution highest
  else
    echo "Skipping $folder due to no uv.lock"
  fi
  echo
done

cd "$CWD" || exit
