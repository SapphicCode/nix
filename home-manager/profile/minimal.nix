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
    micro

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
    PATH="${pkgs.chezmoi}/bin:${pkgs.git}/bin:${pkgs.git-lfs}/bin:''${PATH}"

    $DRY_RUN_CMD chezmoi init git.sapphicco.de/SapphicCode/dotfiles
    $DRY_RUN_CMD chezmoi update -a
    $DRY_RUN_CMD chezmoi git status
  '';
}
