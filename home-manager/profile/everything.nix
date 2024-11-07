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

  home.packages = with pkgs; [
    # more shells!
    xonsh

    # all remaining (occasional use) tools
    mods
    ollama
    gh
    nb
    yt-dlp
    jwt-cli
    fossil
    pipx # in case of fire break glass
    jujutsu
    taskwarrior3
    taskwarrior-tui

    # transcoding / image manipulation
    ffmpeg
    imagemagickBig
    exiftool
    libjxl
    imagemagickBig

    # cloud utils
    awscli2

    # programming languages in global context
    python312
    python312Packages.ipython
    go

    # other programming language tooling
    stylua
  ];
}
