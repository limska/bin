#!/bin/bash

TOPDIR=sicle
PYVER=3.13
TOP=$(pwd)

mkdir $TOPDIR
cd $TOPDIR

export UV_CACHE_DIR=$(pwd)/cache
uv venv --no-project --python $PYVER venv --verbose --relocatable
source venv/bin/activate

git clone --depth=1 git@github.com:StromungsRaum/runner.git 
git clone --depth=1 git@github.com:StromungsRaum/simodclustercomponents.git 
git clone --depth=1 git@github.com:StromungsRaum/simodlib.git 
cd runner
ls -ltra
rm -rf .git
uv sync
cd ..
cd simodlib
rm -rf .git
uv sync
cd ..
cd simodclustercomponents
rm -rf .git
cd ..

uv pip install -e simodlib
uv pip install -e runner

cd runner
./scripts/run --help
./scripts/run pipeline centripump --help
./scripts/run pipeline centri_pump --help
cd ..
ls
cd ${TOP}
tar czvf "${TOPDIR}_$(date +'%Y_%m_%d-%H%M').tar.gz" $TOPDIR 
ls

