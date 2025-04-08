{...}: {
  systemd.network = {
    netdevs."10-br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks."11-ether" = {
      matchConfig.Name = "en*";
      networkConfig.Bridge = "br0";
    };

    networks."20-br0" = {
      matchConfig.Name = "br0";
      networkConfig.DHCP = "yes";
    };
  };
}
