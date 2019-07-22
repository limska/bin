#!/bin/bash

install_nxn()
{
  CAE_NXN=$1
  CAE_NXN_ID=$2
  INSTALL_DIR=$3
  ID_FILE=$4

  if [ ! -d "${INSTALL_DIR}" ] ; then
    echo "Making install folder ${INSTALL_DIR}."
    mkdir -p ${INSTALL_DIR}
  fi

  echo cd ${INSTALL_DIR}
  cd ${INSTALL_DIR}

  echo scp ${MILFORD_USER}@${MILFORD_HOST}:${CAE_NXN_ID} ${INSTALL_DIR}/${ID_FILE}
  scp ${MILFORD_USER}@${MILFORD_HOST}:${CAE_NXN_ID} ${INSTALL_DIR}/${ID_FILE}

  VERSIONFILE=${INSTALL_DIR}/${ID_FILE}
  if [ ! -f ${VERSIONFILE} ] ; then
    echo "Can not find ${VERSIONFILE}"
    return 1
  fi

  VERSION=`cat ${VERSIONFILE} | sed -e 's/[^0-9.]//g'`
  echo "VERSION=$VERSION"

  INSTALL_DIR_FULL=${INSTALL_DIR}/${VERSION}

  if [ -d "${INSTALL_DIR_FULL}" ] ; then
    echo "Latest version synced ${INSTALL_DIR_FULL}"
    return 2
  fi

  echo mkdir -p ${INSTALL_DIR_FULL}
  mkdir -p ${INSTALL_DIR_FULL}

  echo "cd ${INSTALL_DIR_FULL}"
  cd ${INSTALL_DIR_FULL}
  echo ssh  ${MILFORD_USER}@${MILFORD_HOST} tar cf ${CAE_NXN}
  ssh  ${MILFORD_USER}@${MILFORD_HOST} "cd ${CAE_NXN} && tar czf - bin conf scnas *.txt" | tar xzvf -
#echo scp -r ${MILFORD_USER}@${MILFORD_HOST}:${CAE_NXN} ${INSTALL_DIR}/$VERSION
#scp -r ${MILFORD_USER}@${MILFORD_HOST}:${CAE_NXN} ${INSTALL_DIR}/$VERSION

  echo rm -f ${INSTALL_DIR}/current
  rm -f ${INSTALL_DIR}/current

  echo cd ${INSTALL_DIR}
  cd ${INSTALL_DIR}

  echo ln -vs $VERSION current
  ln -vs $VERSION current

  echo ${VERSION}
}


CWD=`pwd`

MILFORD_USER=cd8rit

MILFORD_HOST=cilv6s548.net.plm.eds.com

CAE_NXN_DIR=/plm/cinas/cae_nxn/phase

NXN_VER=$1

LINUX_ID_FILE=nxn_em64t_id.txt
CAE_NXN_LINUX=${CAE_NXN_DIR}/${NXN_VER}/linux
CAE_NXN_LINUX_ID=${CAE_NXN_LINUX}/${LINUX_ID_FILE}
WINDOWS_ID_FILE=nxn_win64_id.txt
CAE_NXN_WINDOWS=${CAE_NXN_DIR}/${NXN_VER}/win64
CAE_NXN_WINDOWS_ID=${CAE_NXN_WINDOWS}/${WINDOWS_ID_FILE}

APPS_DIR=~/apps

APP_NAME=cae_nxn

LINUX_INSTALL_DIR=${APPS_DIR}/${APP_NAME}/lin64
WINDOWS_INSTALL_DIR=${APPS_DIR}/${APP_NAME}/win64

VERSION=
install_nxn ${CAE_NXN_LINUX} ${CAE_NXN_LINUX_ID} ${LINUX_INSTALL_DIR} ${LINUX_ID_FILE}
cd $CWD
echo "VERSION=${VERSION}"

echo cp -v ${LINUX_INSTALL_DIR}/nastranrc ${LINUX_INSTALL_DIR}/$VERSION/conf/nastranrc
cp -v ${LINUX_INSTALL_DIR}/nastranrc ${LINUX_INSTALL_DIR}/$VERSION/conf/nastranrc

install_nxn ${CAE_NXN_WINDOWS} ${CAE_NXN_WINDOWS_ID} ${WINDOWS_INSTALL_DIR} ${WINDOWS_ID_FILE}
cd $CWD
