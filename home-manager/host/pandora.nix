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

  # nixpkgs.overlays = [
  #   (self: super: {
  #     ollama-rocm = super.ollama.override {
  #       acceleration = "rocm";
  #       stdenv = super.ccacheStdenv;
  #     };
  #   })
  # ];
  # systemd.user.services.ollama = {
  #   Unit.Description = "AI bullshit";
  #   Service.ExecStart = "${pkgs.ollama-rocm}/bin/ollama serve";
  #   Service.Environment = ["HSA_OVERRIDE_GFX_VERSION=11.0.2"];
  #   Install.WantedBy = ["default.target"];
  # };

  imports = [
    ../profile/graphical.nix
  ];
}
