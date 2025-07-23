hostname := `if [ "$(uname)" = "Darwin" ]; then cat ~/.hostname 2> /dev/null || scutil --get ComputerName; else cat /proc/sys/kernel/hostname; fi`

_default:
    just --list

_pull:
    git pull
    git checkout main

pre-commit: fmt

fmt:
    nix run nixpkgs#alejandra -- .

_nixpkgs_hash OFFSET='1wk':
    #!/usr/bin/env nu

    # bump nixpkgs-unstable
    let offset = (date now) - {{OFFSET}}
    let query = {until: $offset, sha: "nixos-unstable", per_page: 1, page: 1}
    let hash = http get $"https://api.github.com/repos/nixos/nixpkgs/commits?($query | url build-query)" | first | get sha
    print $hash

_update: _pull
    #!/usr/bin/env bash
    set -euxo pipefail
    hash=$(just _nixpkgs_hash)
    sed -i "s!nixpkgs-unstable.url =.*!nixpkgs-unstable.url = \"github:nixos/nixpkgs/${hash}\";!" flake.nix

update: _pull _update
    # update the flake
    nix flake update
    git restore --staged . || true
    git add flake.nix flake.lock

    # commit our update
    git commit -m "flake: update inputs"

switch-hm: _pull
    home-manager switch --flake '.#{{hostname}}'

switch-nixos: _pull
    sudo nixos-rebuild switch --flake '.#{{hostname}}'

switch-darwin: _pull
    nix run nix-darwin -- build --flake '.#{{hostname}}'
    ls -l result/sw/bin/nix
    echo 'Waiting for Full Disk Access...' && read
    sudo result/activate

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
