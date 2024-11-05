{
  pkgs,
  stable,
  ...
}: {
  imports = [
    ./minimal.nix
  ];

  home.packages = with pkgs; [
    nushell # crazy powerful shell

    # shell plugins
    zoxide
    #atuin

    # fancier TUIs
    btop

    # neovim soft dependencies
    efm-langserver
    fzf
    ripgrep
    gcc

    # containers
    podman
    docker-client
    docker-compose

    # tools
    hyfetch
    restic
    gnupg
    fq
    just
    halp
    gum
    stable.numbat
    devbox
  ];
}
