#!/usr/bin/env bash

set -e # exit on first error

# change working dir to the script dir
cd "$(dirname "$0")/.."

echo "Current directory: $(pwd)"

echo "Running (homebrew) swift-format recursively:"

set -x # print subsequent commands

swift-format --in-place --recursive --parallel .

swift-format lint --strict --recursive --parallel .