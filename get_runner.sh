#!/bin/bash

mkdir runner
cd runner

curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$(pwd)/bin" sh

git clone git@github.com:StromungsRaum/runner.git
git clone git@github.com:StromungsRaum/simodlib.git

echo
echo "Update PATH befor using:"
echo "export PATH=$(pwd)/bin:\$PATH"
echo
echo "To test:"
echo "$(pwd)/runner/scripts/run --help"
echo
