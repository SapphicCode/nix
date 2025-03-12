{lib, ...}: {
  virtualisation.podman.enable = lib.mkDefault true;
  virtualisation.podman.dockerSocket.enable = true;
  systemd.timers.podman-auto-update.wantedBy = ["timers.target"];
  networking.firewall.trustedInterfaces = ["podman+"];
}
