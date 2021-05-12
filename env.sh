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
NINJA=$(ls -1dtr ${DEV_HOME}/ninja/1.6.0/linux-x86_64/bin | tail -n 1)
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

GCC_BIN=
if [ -d "${DEV_HOME}/star" ] ; then
    GCC_BIN=$(${DEV_HOME}/star/bin/map_compiler)/bin
else
    GCC_BIN=$(ls -1dtr ${DEV_HOME}/compilers/linux-x86_64-[0-9.]*/gnu9.2.0/bin | tail -n 1)
fi
echo "GCC_BIN=$GCC_BIN"
if [ -d "$GCC_BIN" -a -z "`echo $PATH | grep $GCC_BIN`" ] ; then
  export PATH=$GCC_BIN:$PATH
  echo "Adding gcc $GCC_BIN to PATH"
fi

CLANG_BIN=
if [ -d "${DEV_HOME}/star" ] ; then
    CLANG_BIN=$(${DEV_HOME}/star/bin/map_compiler -env clang)/bin
else
    CLANG_BIN=$(ls -1dtr ${DEV_HOME}/compilers/linux-x86_64-2.[0-9]*/clang10.0.0/bin | tail -n 1)
fi
echo "CLANG_BIN=$CLANG_BIN"
if [ -d "$CLANG_BIN" -a -z "`echo $PATH | grep $CLANG_BIN`" ] ; then
  export PATH=$CLANG_BIN:$PATH
  echo "Adding clang $CLANG_BIN to PATH"
fi

GCC_LIB=`dirname ${GCC_BIN}`/lib64
echo "GCC_LIB=$GCC_LIB"
if [ -d "$GCC_LIB" -a -z "`echo ${LD_LIBRARY_PATH} | grep $GCC_LIB`" ] ; then
  export LD_LIBRARY_PATH=$GCC_LIB:${LD_LIBRARY_PATH}
  echo "Adding gcc/lib64 $GCC_LIB to LD_LIBRARY_PATH"
fi

export CC=${GCC_BIN}/gcc
export CXX=${GCC_BIN}/g++
