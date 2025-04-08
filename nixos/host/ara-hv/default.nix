{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profile/server.nix
    ../../module/systemd-networkd.nix
  ];

  networking.hostName = "ara-hv";
  networking.hostId = "1e17b561";

  system.stateVersion = "24.11";
}
