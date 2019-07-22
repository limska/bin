#!/bin/sh

set -x

cd /users/lonli6009a/sava/src/starccm+/dev

pwd

rm -rf startest

git clone git@stash.cd-adapco.com:ups/startest.git

cd startest

pwd

bin/rsync_starmirror -lib

make -j 6

make MODULES="coSimulationStarBasicOperations" VERBOSE=1

bin/startest -m coSimulationStarBasicOperations

