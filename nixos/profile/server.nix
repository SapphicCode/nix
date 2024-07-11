{...}: {
  imports = [
    ../module/openssh.nix
    ../module/tailscale.nix
    ../module/user/sapphiccode.nix
  ];

  # Hardware > Memory
  zramSwap.enable = true;
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
  };

  # Hardware > Networking
  services.resolved.enable = true;

  # Hardware > Firmware
  services.fwupd.enable = true;

  # Security
  security.sudo.wheelNeedsPassword = false;

  # Software > Maintenance
  services.zfs.trim.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  # Software > Everyday
  nix.settings.experimental-features = ["nix-command" "flakes"];
  enviroment.systemPackages = with pkgs; [];
  programs.gnupg.agent.enable = true;

  # Software > Server stuff
  virtualisation.podman.enable = true;
}
