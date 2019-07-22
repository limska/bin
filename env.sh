#!/bin/zsh

DEV_HOME=$HOME/src/starccm/dev
echo "DEV_HOME=${DEV_HOME}"

# put cmake on path
CMAKE_DIR=$(ls -1dtr ${DEV_HOME}/cmake/[0-9.]*/linux-x86_64/bin | tail -n 1)
echo "CMAKE_DIR=$CMAKE_DIR"
if [ -z "`echo $PATH | grep ${CMAKE_DIR}`" ] ; then
  export PATH=$CMAKE_DIR:$PATH
  echo "Adding cmake ${CMAKE_DIR} to PATH"
fi

# put ninja on path
NINJA=$(ls -1dtr ${DEV_HOME}/ninja/[0-9.]*/linux-x86_64/bin | tail -n 1)
echo "NINJA=$NINJA"
if [ -d "$NINJA" -a -z "`echo $PATH | grep $NINJA`" ] ; then
  export PATH=$NINJA:$PATH
  echo "Adding ninja $NINJA to PATH"
fi

# put python 3 on path
PYTHON=$(ls -1dtr ${DEV_HOME}/python/3.*/linux-x86_64/bin | tail -1)
echo "PYTHON=$PYTHON"
if [ -d "$PYTHON" -a -z "`echo $PATH | grep $PYTHON`" ] ; then
  export PATH=$PYTHON:$PATH
  echo "Adding python $PYTHON to PATH"
fi

BINUTILS=$(ls -1dtr ${DEV_HOME}/binutils/[0-9.]*/linux-x86_64/bin | tail -n 1)
echo "BINUTILS=$BINUTILS"
if [ -d "$BINUTILS" -a -z "`echo $PATH | grep $BINUTILS`" ] ; then
  export PATH=$BINUTILS:$PATH
  echo "Adding binutils $BINUTILS to PATH"
fi

GCC_BIN=
if [ -d "${DEV_HOME}/star" ] ; then
    GCC_BIN=$(${DEV_HOME}/star/bin/map_compiler)/bin
else
    GCC_BIN=$(ls -1dtr ${DEV_HOME}/compilers/linux-x86_64-[0-9.]*/gnu7.1.0/bin | tail -n 1)
fi
echo "GCC_BIN=$GCC_BIN"
if [ -d "$GCC_BIN" -a -z "`echo $PATH | grep $GCC_BIN`" ] ; then
  export PATH=$GCC_BIN:$PATH
  echo "Adding gcc $GCC_BIN to PATH"
fi

export CC=${GCC_BIN}/gcc
export CXX=${GCC_BIN}/g++
