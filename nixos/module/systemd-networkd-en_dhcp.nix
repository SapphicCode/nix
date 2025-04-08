{...}: {
  systemd.networkd.networks.main = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
  };
}
