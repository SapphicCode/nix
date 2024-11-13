{pkgs}:
with pkgs;
  [
    crypsetup
  ]
  ++ import ./00-core.nix {inherit pkgs;}
