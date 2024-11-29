{
  pkgs,
  lib,
  config,
  ...
}: {
  launchd.agents = {
    yubikey-agent = {
      enable = true;
      config = {
        ProgramArguments = ["${pkgs.yubikey-agent}/bin/yubikey-agent" "-l" "${config.home.homeDirectory}/Library/Caches/yubikey-agent.sock"];
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
      };
    };
    pueue = {
      enable = true;
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
  };
}
