# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  imports = [
    # Include the OrbStack-specific configuration.
    ../module/orbstack.nix

    ../profile/server.nix
  ];

  networking.hostName = "eule";

  systemd.timers.restic.enable = false;
  services.telegraf.enable = false;
  services.vector.enable = false;

  virtualisation.podman.enable = false;
  virtualisation.docker.enable = true;
}
