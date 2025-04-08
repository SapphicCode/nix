{lib, ...}: {
  virtualisation.podman.enable = lib.mkDefault true;
  virtualisation.podman.dockerSocket.enable = true;
  systemd.timers.podman-auto-update.wantedBy =
    if config.virtualisation.podman.enable
    then ["timers.target"]
    else [];
  networking.firewall.trustedInterfaces = ["podman+"];
}
