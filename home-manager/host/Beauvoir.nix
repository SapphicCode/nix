{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/Users/sapphiccode";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    coreutils
    gnugrep
    gnused
  ];

  imports = [
    ../profile/everything.nix
  ];
}
