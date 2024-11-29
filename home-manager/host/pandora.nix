{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/home/sapphiccode";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    backblaze-b2
  ];

  services.syncthing.enable = true;

  systemd.user.services.kanata = {
    Unit.Description = "Keyboard remapper";
    Service.Type = "notify";
    Service.ExecStart = "${pkgs.kanata}/bin/kanata";
    Service.Restart = "on-failure";
    Service.RestartSec = "1s";
    Install.WantedBy = ["default.target"];
  };

  imports = [
    ../profile/everything.nix
    ../module/linux.nix
  ];
}
