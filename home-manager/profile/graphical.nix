{ pkgs, ... }: {
  imports = [
    ./everything.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # obsidian says "next release"
    # https://github.com/NixOS/nixpkgs/issues/273611
    # https://forum.obsidian.md/t/electron-25-is-now-eol-please-upgrade-to-a-newer-version/72878/7
    "electron-25.9.0"
  ];
  home.packages = with pkgs; [
    # web
    chromium

    # misc
    #slack
    obsidian
    vscode
    telegram-desktop
    strawberry

    # other apps
    haruna
    wl-clipboard
    yubikey-manager
    beets

    # fonts
    fira
    ibm-plex

    merriweather

    fira-code
    iosevka
    iosevka-comfy.comfy
  ];
  fonts.fontconfig.enable = true;
}
