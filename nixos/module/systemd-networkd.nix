{...}: {
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  systemd.resolved.enable = true;
  systemd.network = {
    enable = true;

    networks.main = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "yes";
    };
  };
}
