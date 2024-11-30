{pkgs, ...}: {
  systemd.user.services.yubikey-agent = {
    Unit.Description = "yubikey-agent SSH agent";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.yubikey-agent}/bin/yubikey-agent -l %h/.cache/yubikey-agent.sock";
      Restart = "on-failure";
    };
    Install.WantedBy = ["default.target"];
  };
  systemd.user.services.pueue = {
    Unit.Description = "pueue daemon";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.pueue}/bin/pueued";
      Restart = "on-failure";
    };
    Install.WantedBy = ["default.target"];
  };
  home.packages = with pkgs; [yubikey-agent];
}
