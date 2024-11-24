{pkgs, ...}: {
  environment.systemPackages = import ../../pkgset/00-core.nix {inherit pkgs;} ++ import ../../pkgset/10-minimal.nix {inherit pkgs;};
}
