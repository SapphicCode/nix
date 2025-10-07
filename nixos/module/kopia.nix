{pkgs, ...}: {
  systemd.services.kopia = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    serviceConfig.ExecStart = "${pkgs.kopia}/bin/kopia snapshot create /";
    serviceConfig.Environment = "HOME=%h";
  };
  systemd.timers.kopia = {
    timerConfig.OnStartupSec = "15m";
    timerConfig.OnUnitActiveSec = "1h";
    wantedBy = ["timers.target"];
  };
}
