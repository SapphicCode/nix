# bazzite configuration
{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/var/home/sapphiccode";
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
      IOSchedulingClass = "idle";

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
  };

  imports = [
    ../profile/comfortable.nix
  ];
}
