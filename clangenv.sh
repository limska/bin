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
#PYTHON=$(ls -1dtr ${DEV_HOME}/python/3.*/linux-x86_64/bin | tail -1)
#echo "PYTHON=$PYTHON"
#if [ -d "$PYTHON" -a -z "`echo $PATH | grep $PYTHON`" ] ; then
#  export PATH=$PYTHON:$PATH
#  echo "Adding python $PYTHON to PATH"
#fi

BINUTILS=$(ls -1dtr ${DEV_HOME}/binutils/[0-9.]*/linux-x86_64/bin | tail -n 1)
echo "BINUTILS=$BINUTILS"
if [ -d "$BINUTILS" -a -z "`echo $PATH | grep $BINUTILS`" ] ; then
  export PATH=$BINUTILS:$PATH
  echo "Adding binutils $BINUTILS to PATH"
fi

CLANG_BIN=
if [ -d "${DEV_HOME}/star" ] ; then
    CLANG_BIN=$(${DEV_HOME}/star/bin/map_compiler -env clang7.0)/bin
else
    CLANG_BIN=$(ls -1dtr ${DEV_HOME}/compilers/linux-x86_64-[0-9.]*/clang7.0.1/bin | tail -n 1)
fi
echo "CLANG_BIN=$CLANG_BIN"
if [ -d "$CLANG_BIN" -a -z "`echo $PATH | grep $CLANG_BIN`" ] ; then
  export PATH=$CLANG_BIN:$PATH
  echo "Adding clang $CLANG_BIN to PATH"
fi

export CC=${CLANG_BIN}/clang
export CXX=${CLANG_BIN}/clang++
