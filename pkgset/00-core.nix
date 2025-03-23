{pkgs}:
with pkgs;
  [
    # utility
    zsh
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
