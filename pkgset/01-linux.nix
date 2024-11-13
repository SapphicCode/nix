{pkgs}:
with pkgs;
  [
    cryptsetup
  ]
  ++ import ./00-core.nix {inherit pkgs;}
