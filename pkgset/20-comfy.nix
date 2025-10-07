{pkgs}:
with pkgs; [
  nushell # crazy powerful shell

  # git
  mergiraf

  # shell plugins
  zoxide
  #atuin

  # fancier TUIs
  btop
  zellij

  # neovim soft dependencies
  efm-langserver
  fzf
  ripgrep
  gcc

  # containers
  podman
  docker-client
  docker-compose

  # tools
  hyfetch
  restic
  kopia
  gnupg
  fq
  just
  halp
  gum
  devbox
  pueue
  numbat
  hl-log-viewer
  nix-output-monitor

  # programming language bootstrappers
  uv
  rustup
]
