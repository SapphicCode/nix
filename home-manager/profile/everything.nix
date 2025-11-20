{pkgs, ...}: {
  imports = [
    ./comfortable.nix
  ];

  home.packages = import ../../pkgset/50-everything.nix {
    inherit pkgs;
  };
}
