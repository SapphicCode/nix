{pkgs}:
with pkgs; [
  # utility
  curl
  pv
  gptfdisk
  gitFull

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
]
