{pkgs}:
with pkgs;
  [
    # utility
    zsh
    nushell
    curl
    pv
    gptfdisk
    git

    # finding
    fd
    ripgrep

    # parsing
    jq
    yq-go

    # compressing
    zstd

    # editing
    less
    micro
    helix
  ]
  ++ (
    if pkgs.stdenv.isLinux
    then
      with pkgs; [
        cryptsetup
      ]
    else []
  )
