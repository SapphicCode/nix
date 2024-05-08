home := `echo $HOME`
universe := home / "dev" / "1p" / "universe"
hostname := `hostname -s`

_default:
    just --list

update:
    #!/usr/bin/env nu
    cd "{{universe}}"

    let offset = (date now) - ("3day" | into duration)
    let query = {until: $offset, sha: "master", per_page: 1, page: 1}
    let hash = http get $"https://api.github.com/repos/nixos/nixpkgs/commits?($query | url build-query)" | first | get sha
    sed -i $'s!nixpkgs-unstable.url =.*!nixpkgs-unstable.url = "github:nixos/nixpkgs/($hash)";!' flake.nix
    git add flake.nix
    nix flake update
    git add flake.lock
    git commit -m "flake: update inputs"


rebuild:
    chezmoi update -a
    git -C '{{universe}}' pull
    home-manager switch --flake '{{universe}}#{{hostname}}'
