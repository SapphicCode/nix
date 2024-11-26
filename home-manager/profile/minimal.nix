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
    PATH="${pkgs.coreutils}/bin:$HOME/.nix-profile/bin:$PATH"
    run chezmoi init git.sapphiccode.net/SapphicCode/dotfiles
    run chezmoi update -a
    run chezmoi git status
  '';
}
