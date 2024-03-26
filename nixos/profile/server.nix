{...}: {
  imports = [
    ../module/aarch64-fixes.nix
    ../module/openssh.nix
    ../module/tailscale.nix
    ../module/user/sapphiccode.nix
  ];

  security.sudo.wheelNeedsPassword = false;
  virtualisation.podman.enable = true;
}
