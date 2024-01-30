{ pkgs, ... }: {
  imports = [
    ./comfortable.nix
  ];

  home.packages = with pkgs; [
    # more shells!
    xonsh

    # all remaining (occasional use) tools
    _1password
    lima
    charm
    glow
    skate
    ffmpeg
    exiftool
    libjxl
    nb
    watchman
    python311Packages.pywatchman

    # Python
    python311Full
    python311Packages.black
    python311Packages.isort
    ruff
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

    # Elixir
    elixir

    # Lua
    stylua

    # JS
    bun
  ];

  # alias for `node` -> `bun`
  home.file.".local/bin/node" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      exec ${pkgs.bun}/bin/bun "$@"
    '';
    executable = true;
  };
}
