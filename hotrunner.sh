#!/bin/bash


set -o noglob

uv venv --python $1

source .venv/bin/activate

uv pip install -e ../simodlib[dev]
uv pip install -e ../geolib[dev]
uv pip install -e ../hotrunner[dev]
uv pip install pymeshfix --no-deps

./run/runHotrunner.sh $2
