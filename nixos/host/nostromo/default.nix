{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../module/systemd-boot.nix
    ../../module/systemd-networkd-en_dhcp.nix
    ../../profile/server_x86_64-linux.nix
    ../../module/kopia.nix
  ];

  networking.hostName = "nostromo";
  virtualisation.incus.agent.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.flags = ["--volumes"];
}
