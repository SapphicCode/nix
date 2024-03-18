{pkgs, ...}: {
  imports = [
    ./comfortable.nix
  ];

  nixpkgs.overlays = [
    # of the two ways to achieve this, this is definitely the less obnoxious one
    # (the other is .overrideAttrs and messing with hooks... let's not.)
    (self: super: {
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
    })
  ];

  home.packages = with pkgs; [
    # more shells!
    xonsh

    # all remaining (occasional use) tools
    _1password
    charm
    gum
    skate
    ffmpeg
    imagemagickBig
    exiftool
    libjxl
    imagemagickBig
    nb
    ollama

    # Python
    python311Full
    python311Packages.black
    python311Packages.isort
    python310NoAliases
    ruff
    pyright
    pre-commit
    poetry
    pdm
    python311Packages.ipython
    pipx # in case of fire break glass

    # cloud utils
    awscli2

    # database development
    mongosh
    postgresql_16 # `psql`

    # misc. other programming languages
    go
    gleam

    # other programming language tooling
    stylua

    # JS
    bun
    (writeShellScriptBin "node" ''
      exec "${pkgs.bun}/bin/bun" "$@"
    '')
  ];
}
