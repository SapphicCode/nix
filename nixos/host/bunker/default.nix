{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/incus-guest.nix")
    ./hardware-configuration.nix
    ../../module/systemd-networkd-en_dhcp.nix
    ../../profile/server_x86_64-linux.nix
    ../../module/user/sapphiccode.nix
  ];

  networking.hostName = "bunker";
  virtualisation.incus.agent.enable = true;
}
