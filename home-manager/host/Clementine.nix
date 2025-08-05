{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/Users/sapphiccode";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    ab-av1
  ];

  services.syncthing.enable = true;

  imports = [
    ../profile/everything.nix
    ../module/macos.nix
  ];
}
