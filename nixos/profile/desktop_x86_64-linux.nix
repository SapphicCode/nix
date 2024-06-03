{pkgs, ...}: {
  imports = [
    ./desktop.nix
  ];

  environment.systemPackages = with pkgs; [
    # web:
    thorium-browser

    # fun:
    sunvox
  ];
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {};
      extraLibraries = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          gamescope
        ];
    };
  };

  hardware.sane.extraBackends = with pkgs; [
    epsonscan2
  ];
}
