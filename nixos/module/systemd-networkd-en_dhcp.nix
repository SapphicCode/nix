{...}: {
  systemd.network.networks.main = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
  };
}
