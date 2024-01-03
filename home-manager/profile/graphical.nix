{ pkgs, ... }: {
  imports = [
    ./everything.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # obsidian says "next release"
      # https://github.com/NixOS/nixpkgs/issues/273611
      # https://forum.obsidian.md/t/electron-25-is-now-eol-please-upgrade-to-a-newer-version/72878/7
      "electron-25.9.0"
    ];
  };
  home.packages = with pkgs; [
    firefox

    wezterm

    slack
    obsidian
    vscode

    fira
    fira-code
  ];
}
