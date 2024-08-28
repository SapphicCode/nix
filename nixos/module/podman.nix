{...}: {
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  networking.firewall.trustedInterfaces = ["podman+"];
}
