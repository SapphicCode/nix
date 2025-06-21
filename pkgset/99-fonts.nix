{pkgs}:
with pkgs; [
  fira
  ibm-plex
  merriweather

  fira-code
  nerd-fonts.fira-code
  iosevka-bin
  (iosevka-bin.override {variant = "SS05";})
  nerd-fonts.iosevka
  departure-mono
]
