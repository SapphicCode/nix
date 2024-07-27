# SteamOS configuration
{pkgs, ...}: {
  home.username = "deck";
  home.homeDirectory = "/home/deck";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  # restic
  systemd.user.services.restic = {
    Unit = {
      Description = "Restic backup task";
      ConditionPathExists = "%h/.config/restic/restic.env";
      ConditionCPUPressure = "50%/1min";
      ConditionMemoryPressure = "50%/1min";
    };
    Service = {
      ExecCondition = "${pkgs.iputils}/bin/ping -c 1 -W 5 1.1.1.1";

      Type = "simple";
      Nice = "10";

      EnvironmentFile = "%h/.config/restic/restic.env";
      ExecStart = "${pkgs.restic}/bin/restic backup -x --exclude-caches --exclude-file=%h/.config/restic/excludes.txt %h";
    };
  };
  systemd.user.timers.restic = {
    Unit.Description = "Restic backup timer";
    Timer = {
      OnStartupSec = "2min";
      OnUnitInactiveSec = "1h";
    };
    Install.WantedBy = ["timers.target"];
  };

  imports = [
    ../profile/comfortable.nix
  ];
}
