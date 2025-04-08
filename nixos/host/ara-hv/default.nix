{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profile/server.nix
    ../../module/systemd-boot.nix
    ../../module/systemd-networkd.nix
    ../../module/systemd-networkd-br0_dhcp.nix
  ];

  boot.initrd.luks.devices."luks-root".device = "/dev/nvme0n1p2";

  networking.hostName = "ara-hv";
  networking.hostId = "1e17b561";

  virtualisation.podman.enable = false;

  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };
  networking.nftables.enable = true;
}
