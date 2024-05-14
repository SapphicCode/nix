{
  pkgs,
  unstable,
  ...
}: {
  # Hardware > Power
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.sg_display=0" # avoids graphics glitches
  ];

  services.power-profiles-daemon.enable = true;
  nixpkgs.overlays = [
    (self: super: {
      power-profiles-daemon = unstable.power-profiles-daemon;
    })
  ];
}
