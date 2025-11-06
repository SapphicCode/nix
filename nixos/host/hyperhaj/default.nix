{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../module/systemd-boot.nix
    ../../profile/server_x86_64-linux.nix
    ../../module/systemd-networkd-en_dhcp.nix
    ../../module/incus.nix
  ];

  networking.hostName = "hyperhaj";
  networking.hostId = "ef6c5017";
  networking.firewall.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  services.openssh.ports = [2222];
}
