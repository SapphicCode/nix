{ pkgs, ... }: {
  imports = [
    ./minimal.nix
  ];

  home.packages = with pkgs; [
    nushell # crazy powerful shell

    # fancier TUIs
    btop

    # neovim soft dependencies
    efm-langserver
    fzf
    ripgrep

    # containers
    podman
    docker-client
    docker-compose

    # tools
    hyfetch
    gnupg
    fq
    just
  ];
}
