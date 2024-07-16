{
  pkgs,
  unstable,
  ...
}: {
  # Hardware > Power
  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.sg_display=0" # avoids graphics glitches
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  hardware.sensor.iio.enable = true;
  services.hardware.bolt.enable = true;

  services.power-profiles-daemon.enable = true;
}
