{
  pkgs,
  stable,
  config,
  ...
}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/Users/sapphiccode";
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  launchd.agents.yubikey-agent = {
    enable = true;
    config = {
      ProgramArguments = ["${pkgs.yubikey-agent}/bin/yubikey-agent" "-l" "${config.home.homeDirectory}/Library/Caches/yubikey-agent.sock"];
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
    };
  };

  home.packages = with pkgs;
    [
      yubikey-agent
    ]
    ++ import ../../pkgset/99-fonts.nix {inherit pkgs;}
    ++ import ../../pkgset/99-macos.nix {inherit pkgs;};

  imports = [
    ../profile/everything.nix
  ];
}
