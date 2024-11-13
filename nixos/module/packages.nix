{pkgs, ...}: {
  environment.systemPackages = import ../../pkgset/01-linux.nix {inherit pkgs;} + import ../../pkgset/10-minimal.nix {inherit pkgs;};
}
