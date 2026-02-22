{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ../../profile/server.nix
    ../../module/systemd-boot.nix
  ];

  networking.hostName = "aerie-core";
  networking.useDHCP = true;

  # Auto-upgrade
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://git.sapphiccode.net/SapphicCode/universe";
    allowReboot = true;
    flags = ["--update-input" "nixpkgs"];
    dates = "monthly";
  };

  # Hardware > VM-specific
  virtualisation.incus.agent.enable = true;
}
