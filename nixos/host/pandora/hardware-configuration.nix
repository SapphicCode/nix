# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  boot.initrd.luks.devices = {
    "luks-system".device = "/dev/disk/by-uuid/33c3110f-9153-4fdf-abc5-591615b707a7";
  };

  fileSystems."/" = {
    device = "pandora/root";
    fsType = "zfs";
  };

  fileSystems."/nix/store" = {
    device = "pandora/nix-store";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "pandora/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2F27-9CEC";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
