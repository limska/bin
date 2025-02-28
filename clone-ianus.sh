#!/usr/bin/zsh

CWD=`pwd`

repos=("replib" "ianus-simod" "aerationtanklib" "blow" "diegeolib" "hotrunner" "geolib" "simodlib" "kube" "simodclustercomponents" "container" "slv" "featflower" "scripts")

root=$HOME/repo
if [ $# -gt 1 ]; then
  folders=($*)
  root=$(pwd)
fi

echo "repos=$repos"
echo "root=$root"

for f in "${repos[@]}"; do
    folder="$root/$f"
    echo "Checking $folder"
    cd $root
    if [ ! -d "$folder" ] ; then
        echo "Cloning $f"
        echo git clone git@github.com:StromungsRaum/$f.git
        git clone git@github.com:StromungsRaum/$f.git
        cd $f
        cd ..
        echo
    else
        echo "Skipping $folder"
    fi
done

cd $CWD
