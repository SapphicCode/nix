#!/usr/bin/env bash

set -euxo pipefail

cd "$(dirname $0)"
nix run home-manager -- switch --flake .#"$(whoami)@$(hostname -s)
sudo nixos-rebuild switch --flake .#"$(hostname -s)"
