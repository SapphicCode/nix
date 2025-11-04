{...}: {
  networking.nftables.enable = true;
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };
}
