#!/bin/sh

echo_error() {
    echo "Error: $1"
    shift
    for line do echo "       $line"; done
}

echo_info() {
    echo "Info: $1"
    shift
    for line do echo "      $line"; done
}

echo_warning() {
    echo "Warning: $1"
    shift
    for line do echo "         $line"; done
}

usage () {
cat << \EOF

Usage:  go.sh

EOF

if [ $# -gt 0 ]; then
    echo_error "$*"
fi

exit 1
}

DEST=`pwd`
EXECUTABLENAME=spring

export PATH=/users/porting/dep/compilers/INTEL/11.1.046/bin:$PATH
CCMP=`which starccm+ 2> /dev/null`
if [ -z "$CCMP" ] ; then
  usage 'Please put starccm+ on the path. export PATH=/path/to/STAR-CCM+/star/bin:$PATH'
fi
STARBIN=`dirname $CCMP`
STAR=`dirname $STARBIN`
RELEASE="$STAR/RELEASE_NOTES"
if [ -f "$RELEASE" ] ; then
  echo ". $RELEASE" 
. $RELEASE 
else
  usage "Can not find $RELEASE"
fi


DEVHOME=`dirname $STAR`
DISTDIR="$STAR/dist"

if [ -d "$DISTDIR" ] ; then
  echo rm -rf $DISTDIR
  rm -rf $DISTDIR
  echo
fi

MAKEDIST=$STAR/config/make-distrib
if [ -f "$MAKEDIST" ] ; then
  echo $MAKEDIST apiexamples $DEVHOME 
  $MAKEDIST apiexamples $DEVHOME 
  echo
else
  usage "Can not find $MAKEDIST"
fi

CCMVERSION="STAR-CCM+${release_number}"
TARFILE="$STAR/dist/${CCMVERSION}_apiexamples.tar.gz"
if [ -f "$TARFILE" ] ; then
  echo "(cd $DEST; tar xzvf $TARFILE)"
  (cd $DEST; tar xzvf $TARFILE)
else
  usage "Failed to build $TARFILE"
fi

echo "Build apiexamples"
# /zagor3/sava/test/API/distTest/STAR-CCM+9.01.063/star/examples/api/SpringMass
SPRINGMASS="$DEST/$CCMVERSION/star/examples/api/SpringMass"
if [ -d "$SPRINGMASS" ] ; then
  echo "(cd $DEST; buildapi -cfiles $SPRINGMASS/*.cpp -executable $EXECUTABLENAME)"
  (cd $DEST; buildapi -cfiles $SPRINGMASS/*.cpp -executable $EXECUTABLENAME)
  echo
else
  usage "Can not find SpringMass directory $SPRINGMASS"
fi

EXECUTABLE="$DEST/out/$EXECUTABLENAME"
if [ -d "$SPRINGMASS" ] ; then
  echo "starapi $EXECUTABLE"
  starapi $EXECUTABLE
  echo
else
  usage "Failed to build executable $EXECUTABLE"
fi
