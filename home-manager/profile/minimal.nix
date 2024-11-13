{
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  home.packages = import ../../pkgset/00-core.nix {inherit pkgs;} ++ import ../../pkgset/10-minimal.nix {inherit pkgs;};

  programs.home-manager.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.activation.chezmoi = lib.hm.dag.entryAfter ["installPackages"] ''
    PATH="${pkgs.chezmoi}/bin:${pkgs.git}/bin:${pkgs.git-lfs}/bin:''${PATH}"

    $DRY_RUN_CMD chezmoi init git.sapphicco.de/SapphicCode/dotfiles
    $DRY_RUN_CMD chezmoi update -a
    $DRY_RUN_CMD chezmoi git status
  '';
}
