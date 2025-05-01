{pkgs, ...}: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.pop-shell
  ];

  # seems more well-behaved under Gnome:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
