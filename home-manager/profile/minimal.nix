{
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # bare minimum
    gitFull
    git-lfs
    delta # pager for git
    chezmoi

    # shell
    fish
    starship
    direnv

    # TUIs
    tmux
    htop
    ncdu
    neovim

    # tools
    pv
    lsof
    fd
    age
    age-plugin-yubikey
    zstd
    jq
    yq-go
    rclone
    mkpasswd
    pwgen

    # dev tools
    alejandra
  ];

  programs.home-manager.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.activation.chezmoi = lib.hm.dag.entryAfter ["installPackages"] ''
    $DRY_RUN_CMD ${pkgs.chezmoi}/bin/chezmoi init git.sapphicco.de/SapphicCode/dotfiles
    $DRY_RUN_CMD ${pkgs.chezmoi}/bin/chezmoi update -a
  '';
}
