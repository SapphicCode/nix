{
  pkgs,
  stable,
  ...
}: {
  imports = [
    ./comfortable.nix
  ];

  nixpkgs.overlays = [
    # of the two ways to achieve this, this is definitely the less obnoxious one
    # (the other is .overrideAttrs and messing with hooks... let's not.)
    (_self: super: {
      python310NoAliases = pkgs.buildEnv {
        name = "python-3.10-no-aliases";
        paths = [super.python310];
        pathsToLink = ["/bin" "/share/man/man1"];
        postBuild = ''
          for binary in 2to3 idle idle3 pydoc pydoc3 python python-config python3 python3-config; do
            rm $out/bin/$binary
          done
          for man in python.1.gz python3.1.gz; do
            rm $out/share/man/man1/$man
          done
        '';
      };
      python311Extra = super.python311.withPackages (pypkgs:
        with pypkgs; [
          click
          requests
          pyyaml
          ipython
          pytz
        ]);
    })
  ];

  home.packages = import ../../pkgset/50-everything.nix {
    inherit pkgs;
    fallback = stable;
  };
}
