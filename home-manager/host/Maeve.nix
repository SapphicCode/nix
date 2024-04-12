{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/Users/sapphiccode";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    bash
    coreutils
    curl
    gnugrep
    gnused
    lima
  ];

  services.syncthing.enable = true;

  launchd.agents.ollama = {
    enable = true;
    config = {
      ProgramArguments = ["${pkgs.ollama}/bin/ollama" "serve"];
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
    };
  };

  imports = [
    ../profile/everything.nix
    ../profile/fonts.nix
  ];
}
