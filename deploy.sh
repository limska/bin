#!/bin/bash

SIF_FILE=$1
LINK_FILE=$2

if [ -f "$SIF_FILE" ] ; then
    echo "Sif file: $SIF_FILE"
else
    echo "Missing file $SIF_FILE"
    exit 1
fi
if [ -n "$LINK_FILE" ] ; then
    echo "Link:     $LINK_FILE"
else
    echo "Missing name  of link"
fi

SIF_NAME=$(basename ${SIF_FILE})
echo "SIF_NAME: ${SIF_NAME}"
LINK_BASE=$(basename ${LINK_FILE} .sif)
echo "LINK_BASE: ${LINK_BASE}"

echo "ssh lapras 'cd /mnt/Pool1/container && ls -l ${LINK_FILE} 2> /dev/null'"
LINK_EXISTS=$(ssh lapras "cd /mnt/Pool1/container && ls -l ${LINK_FILE} 2> /dev/null")
if [ -n "$LINK_EXISTS" ] ; then
    echo "Removing old link ${LINK_EXISTS}"
    echo "ssh lapras 'cd /mnt/Pool1/container && rm -vf ${LINK_FILE}'"
    ssh lapras 'cd /mnt/Pool1/container && rm -vf ${LINK_FILE}'
fi

echo "Sending file to lapras"
echo "rsync -avP ${SIF_FILE} lapras:/mnt/Pool1/container"
rsync -avP ${SIF_FILE} lapras:/mnt/Pool1/container

echo "Creating new link"
echo "ssh lapras 'cd /mnt/Pool1/container && ln -s ${SIF_NAME}  ${LINK_FILE}'"
ssh lapras "cd /mnt/Pool1/container && ln -s ${SIF_NAME}  ${LINK_FILE}"

echo "Sif files"
echo "ssh lapras 'cd /mnt/Pool1/container && ls -l ${LINK_BASE}*.*'"
ssh lapras "cd /mnt/Pool1/container && ls -l ${LINK_BASE}*.*"

echo "md5sum ${SIF_FILE}"
md5sum ${SIF_FILE}

echo "ssh lapras 'cd /mnt/Pool1/container && ls -l ${LINK_FILE}'"
ssh lapras "cd /mnt/Pool1/container && ls -l ${LINK_FILE}"

