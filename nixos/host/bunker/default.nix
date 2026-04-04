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

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    ensureDatabases = ["sapphiccode"];
    ensureUsers = [{
      name = "sapphiccode";
      ensureClauses = {
        login = true;
        superuser = true;
      };
    }];
  };
}
