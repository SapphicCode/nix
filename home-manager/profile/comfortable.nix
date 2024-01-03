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

    # tools
    gnupg
    fq
    syncthing
    podman
    watchman
  ];
}
