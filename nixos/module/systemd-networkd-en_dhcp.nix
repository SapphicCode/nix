{...}: {
  imports = [./systemd-networkd.nix];
  systemd.network.networks.main = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
  };
}
