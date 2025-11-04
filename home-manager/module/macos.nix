{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs;
    (
      if config.launchd.agents.yubikey-agent.enable
      then [yubikey-agent]
      else []
    )
    ++ import ../../pkgset/99-fonts.nix {inherit pkgs;}
    ++ import ../../pkgset/99-macos.nix {inherit pkgs;};

  launchd.agents = {
    yubikey-agent = {
      enable = lib.mkDefault true;
      config = {
        ProgramArguments = ["${pkgs.yubikey-agent}/bin/yubikey-agent" "-l" "${config.home.homeDirectory}/Library/Caches/yubikey-agent.sock"];
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
      };
    };
    pueue = {
      enable = lib.mkDefault true;
      config = {
        ProgramArguments = ["${pkgs.pueue}/bin/pueued"];
        EnvironmentVariables = {
          "PATH" = lib.strings.concatStringsSep ":" [
            "${config.home.homeDirectory}/.local/bin"
            "${config.home.homeDirectory}/dev/go/bin"
            "${config.home.homeDirectory}/.nix-profile/bin"
            "/opt/homebrew/bin"
            "/opt/homebrew/sbin"
            "/usr/local/bin"
            "/usr/bin"
            "/usr/sbin"
            "/bin"
            "/sbin"
          ];
        };
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
      };
    };
    kopia = {
      enable = lib.mkDefault true;
      config = {
        ProgramArguments = [
          "${pkgs.kopia}/bin/kopia"
          "snapshot"
          "create"
          "${config.home.homeDirectory}"
        ];
        ProcessType = "Background";
        LowPriorityBackgroundIO = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/kopia.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/kopia.err";
        StartInterval = 3600;
      };
    };
  };
}
