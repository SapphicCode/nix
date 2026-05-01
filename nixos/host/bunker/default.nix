{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../module/systemd-boot.nix
    ../../module/systemd-networkd-en_dhcp.nix
    ../../profile/server_x86_64-linux.nix
    ../../module/kopia.nix
  ];

  networking.hostName = "bunker";
  virtualisation.incus.agent.enable = true;

  networking.firewall.allowedTCPPorts = [
    5432

    8428
    2003
    4242

    9428
  ];
  networking.firewall.allowedUDPPorts = [
    8089
  ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;

    enableTCPIP = true;
    authentication = ''
      host  all  all  0.0.0.0/0  scram-sha-256
      host  all  all  ::/0       scram-sha-256
    '';

    ensureDatabases = ["sapphiccode"];
    ensureUsers = [
      {
        name = "sapphiccode";
        ensureClauses = {
          login = true;
          superuser = true;
        };
      }
    ];
  };

  services.victorialogs = {
    enable = true;
    extraOptions = ["-retentionPeriod=100y" "-memory.allowedPercent=25"];
  };

  services.victoriametrics = {
    enable = true;
    extraOptions = [
      "-retentionPeriod=100y"
      "-memory.allowedPercent=25"
      "-influxListenAddr=:8089"
      "-graphiteListenAddr=:2003"
      "-opentsdbListenAddr=:4242"
      "-opentsdbHTTPListenAddr=:4242"
      "-promscape.config=/etc/victoriametrics/promscrape.yaml"
    ];
  };
}
