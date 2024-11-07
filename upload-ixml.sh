#!/bin/bash

VERSION=$1
FILE=ixml-$VERSION.tar.gz
DEST_FILE=https://gitinternal.nag.co.uk/api/v4/projects/258/packages/generic/ixml/$VERSION/$FILE
DRY_RUN=${DRY_RUN:=0}

if [ -f ${FILE} ] ; then
  echo "File ${FILE} exists skipping creating achive"
else
  echo tar cvzf $FILE ixml
  if [ ${DRY_RUN} -eq 0 ] ; then
    tar cvzf $FILE ixml
  fi
fi


export PRIVATE_TOKEN=$(cat ~/keys/gitlab-modular-library-personal.token)

echo "curl --header \"PRIVATE-TOKEN:${PRIVATE_TOKEN}\" --tlsv1.3 --verbose --ftp-create-dirs --upload-file ./$FILE $DEST_FILE"
if [ ${DRY_RUN} -eq 0 ] ; then
  curl --header "PRIVATE-TOKEN:${PRIVATE_TOKEN}" --tlsv1.3 --verbose --ftp-create-dirs --upload-file ./$FILE $DEST_FILE
fi

echo sha256sum $FILE
if [ ${DRY_RUN} -eq 0 ] ; then
  sha256sum $FILE
fi
