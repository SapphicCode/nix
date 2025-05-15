{pkgs}:
with pkgs;
  [
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
    timewarrior
    yubikey-manager

    # transcoding / image manipulation
    imagemagickBig
    exiftool
    libjxl
    imagemagickBig

    # cloud utils
    # awscli2 # (broken)

    # programming languages in global context
    python312
    python312Packages.ipython
    go

    # other programming language tooling
    stylua
    pre-commit
    earthly
  ]
  ++ (
    if pkgs.stdenv.isLinux
    then with pkgs; [ffmpeg]
    else []
  )
