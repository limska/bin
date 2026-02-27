#!/bin/bash

TOP_DIR="runner"

if [ -d "${TOP_DIR}" ] ; then
	echo "Directory ${TOP_DIR} already exists. Remove and try again"
	exit 1
fi

mkdir ${TOP_DIR}
cd ${TOP_DIR}

curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$(pwd)/bin" sh

git clone git@github.com:StromungsRaum/runner.git
git clone git@github.com:StromungsRaum/simodlib.git

TARBALL="runner_$(date +'%Y_%m_%d-%H%M').tar.gz"
tar czf $TARBALL runner
echo
echo "Packaged runner: $TARBALL"

echo
echo "Update PATH before using:"
echo "export PATH=$(pwd)/bin:\$PATH"
echo
echo "To test:"
echo "$(pwd)/${TOP_DIR}/scripts/run --help"
echo




