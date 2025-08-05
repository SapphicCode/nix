{pkgs}:
with pkgs; [
  # bare minimum
  git-lfs
  delta # pager for git
  chezmoi

  # shell
  fish
  starship
  direnv

  # TUIs
  tmux
  htop
  ncdu

  # tools
  lsof
  eza
  bat
  age
  age-plugin-yubikey
  rclone
  mkpasswd
  pwgen
  ldns # -> drill

  # dev tools
  alejandra
  nil
]
