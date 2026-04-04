{modulesPath, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../module/systemd-boot.nix
    ../../module/systemd-networkd-en_dhcp.nix
    ../../profile/server_x86_64-linux.nix
  ];

  networking.hostName = "bunker";
  virtualisation.incus.agent.enable = true;
}
