#!/usr/bin/env bash

set -euxo pipefail

cd "$(dirname $0)"

nix flake lock --update-input nixpkgs
git restore --staged '.'
git add flake.lock
git commit -m 'flake: update nixpkgs'
