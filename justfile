hostname := `if [ "$(uname)" = "Darwin" ]; then scutil --get ComputerName; else hostname -s; fi`

_default:
    just --list

_pull:
    git pull
    git checkout main

pre-commit: fmt

fmt:
    nix run nixpkgs#alejandra -- .

update OFFSET='3day': _pull
    #!/usr/bin/env nu

    # bump nixpkgs-unstable
    let offset = (date now) - {{OFFSET}}
    let query = {until: $offset, sha: "master", per_page: 1, page: 1}
    let hash = http get $"https://api.github.com/repos/nixos/nixpkgs/commits?($query | url build-query)" | first | get sha
    sed -i $'s!nixpkgs-unstable.url =.*!nixpkgs-unstable.url = "github:nixos/nixpkgs/($hash)";!' flake.nix
    git add flake.nix

    # update the flake
    nix flake update
    git add flake.lock

    # commit our update
    git commit -m "flake: update inputs"

switch-hm: _pull
    chezmoi update -a
    home-manager switch --flake '.#{{hostname}}'

switch-nixos: _pull
    sudo nixos-rebuild switch --flake '.#{{hostname}}'

switch-darwin: _pull
    nix run nix-darwin -- switch --flake '.#{{hostname}}'

switch:
    #!/usr/bin/env bash

    set -euxo pipefail

    if [ -d "$HOME/.local/state/home-manager" ]; then
        just switch-hm
    fi

    if [ "$(uname)" = "Darwin" ] && grep "darwinSystem" flake.nix | grep -q "{{hostname}}" flake.nix; then
        just switch-darwin
    fi

    if [ "$(uname)" = "Linux" ] && grep -q "NixOS" /etc/os-release; then
        just switch-nixos
    fi
