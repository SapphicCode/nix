{...}: {
  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
