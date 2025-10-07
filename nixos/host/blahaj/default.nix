{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./containers.nix
    ../../module/systemd-boot.nix
    ../../profile/server_x86_64-linux.nix
    ../../module/k3s.nix
    ../../module/podman.nix
    ../../module/podman-user-quadlet.nix
    ../../module/kopia.nix
    ../../module/telegraf.nix
    ../../module/vector.nix
    ../../module/user/hex.nix
    ../../module/user/chaos.nix
  ];

  networking.hostName = "blahaj";
  networking.hostId = "ef32a18b";
  services.qemuGuest.enable = true;

  users.users.sapphiccode.linger = true;
  users.users.hex.linger = true;

  programs.nix-ld.enable = true;

  services.k3s = {
    role = "server";
    extraFlags = [
      "--tls-san=blahaj.sapphiccode.net"
      "--tls-san=blahaj-ng.atlas-ide.ts.net"
      "--disable=traefik"
    ];
  };

  users.users.remote-build = {
    isSystemUser = true;
    group = "nogroup";
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxAjBm1zXctwc9uKgMZVMgNms9UB3Wb4+g8cpUI7nyx"
    ];
  };

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 15080;
      to = 15100;
    }
  ];
}
