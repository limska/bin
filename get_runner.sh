#!/bin/bash

mkdir runner
cd runner

curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$(pwd)/bin" sh

git clone git@github.com:StromungsRaum/runner.git
git clone git@github.com:StromungsRaum/simodlib.git

export PATH=$(pwd)/bin:$PATH
echo "$(pwd)/runner/scripts/run --help"
$(pwd)/runner/scripts/run --help

echo
echo "Update PATH befor using:"
echo "export PATH=$(pwd)/bin:\$PATH"
echo
echo "To test:"
echo "$(pwd)/runner/scripts/run --help"
echo
