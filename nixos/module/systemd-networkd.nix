{...}: {
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  services.resolved.enable = true;
  systemd.network.enable = true;
}
