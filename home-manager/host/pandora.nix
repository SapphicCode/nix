{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/home/sapphiccode";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  systemd.user.services.kanata = {
    Unit.Description = "Keyboard remapper";
    Service.Type = "notify";
    Service.ExecStart = "${pkgs.kanata}/bin/kanata";
    Service.Restart = "on-failure";
    Service.RestartSec = "1s";
    Install.WantedBy = ["default.target"];
  };

  systemd.user.services.ollama = {
    Unit.Description = "AI bullshit";
    Service.ExecStart = "${pkgs.ollama}/bin/ollama serve";
    Install.WantedBy = ["default.target"];
  };

  imports = [
    ../profile/graphical.nix
  ];
}
