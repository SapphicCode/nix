{
  pkgs,
  stable,
  ...
}: {
  imports = [
    ./minimal.nix
  ];

  home.packages = import ../../pkgset/20-comfy.nix {
    inherit pkgs;
  };
}
