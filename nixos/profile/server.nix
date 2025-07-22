{
  lib,
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ../module/openssh.nix
    ../module/tailscale.nix
    ../module/user/sapphiccode.nix
    ../module/user/aurelia.nix
    ../module/user/automata.nix
    ../module/packages.nix
  ];

  # Hardware > Boot
  boot.initrd.systemd.enable = true;

  # Hardware > Memory
  zramSwap.enable = true;
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
  };

  # Hardware > Networking
  services.resolved.enable = lib.mkDefault true;

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
  nix.package = unstable.lixPackageSets.latest.lix;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [];
  programs.gnupg.agent.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05";
}
