{pkgs, ...}: {
  programs.niri.enable = true;
  programs.light.enable = true;
  environment.systemPackages = with pkgs; [
    fuzzel
    mako
    swaylock
    playerctl
    waybar
    font-awesome
    pinentry-gnome3
    wl-clipboard
    darkman
  ];
}
