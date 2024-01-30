{ lib, pkgs, ... }: {
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
    fd
    age
    zstd
    jq
    yq-go
    rclone
    mkpasswd
    pwgen

    # dev tools
    nixpkgs-fmt
  ];

  programs.home-manager.enable = true;

  home.activation.chezmoi = lib.hm.dag.entryAfter [ "installPackages" ] ''
    $DRY_RUN_CMD ${pkgs.chezmoi}/bin/chezmoi init --apply git.sapphicco.de/SapphicCode/dotfiles
  '';
}
