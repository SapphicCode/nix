{pkgs, ...}: {
  imports = [
    ../module/user/sapphiccode.nix
    ../module/tailscale.nix
    ../module/aarch64-fixes.nix
  ];

  # Hardware
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  # Regional
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_IE.UTF-8";

  # Graphical
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Extra packages
  environment.systemPackages = with pkgs; [
    firefox
    vivaldi

    telegram-desktop

    obsidian
  ];

  programs._1password-gui.enable = true;
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      vivaldi-bin
    '';
    mode = "0644";
  };

  system.stateVersion = "23.11";
}
