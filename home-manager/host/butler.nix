{pkgs, ...}: {
  home.username = "beelen";
  home.homeDirectory = "/Users/beelen";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;
  launchd.agents.yubikey-agent.enable = false;

  imports = [
    ../profile/everything.nix
    ../module/macos.nix
  ];
}
