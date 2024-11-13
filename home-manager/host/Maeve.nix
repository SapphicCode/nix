{pkgs, ...}: {
  home.username = "sapphiccode";
  home.homeDirectory = "/Users/sapphiccode";
  home.stateVersion = "23.05";

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
  home.packages = with pkgs;
    [
      ollama
    ]
    ++ import ../../pkgset/99-fonts.nix {inherit pkgs;}
    ++ import ../../pkgset/99-macos.nix {inherit pkgs;};

  imports = [
    ../profile/everything.nix
  ];
}
