#!/bin/sh

WAVEDIR=$HOME/software/Ricardo
WAVEBIN=$WAVEDIR/bin
INPATH=`echo $PATH | grep $WAVEBIN`
if [ -z "$INPATH" ] ; then
  export PATH=$WAVEBIN:$PATH
  echo "Adding $WAVEBIN to PATH"
fi
