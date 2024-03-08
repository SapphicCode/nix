# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  unstable,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.memtest86.enable = true;

  boot.zfs.forceImportRoot = false;

  boot.initrd.systemd.enable = true;

  boot.kernelParams = ["amdgpu.sg_display=0"];

  # Deal with memory issues.
  systemd.watchdog.runtimeTime = "20s";
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
  };
  zramSwap.enable = true;

  networking.hostName = "pandora"; # Define your hostname.
  networking.hostId = "94ad2a33";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = ["lo" "tailscale*"];
  networking.firewall.enable = false;
  services.tailscale.enable = true;
  services.resolved.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Maintenance tasks.
  services.zfs.trim.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the DEs.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.kdeconnect.enable = true;

  programs.sway = {
    enable = true;
    package = unstable.swayfx.override {withBaseWrapper = true;};
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable fingerprints
  services.fprintd = {
    enable = true;
  };
  security.pam.services.login.fprintAuth = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    extraGroups = ["networkmanager" "wheel" "input"];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["sapphiccode"];
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {};
      extraLibraries = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          gamescope
        ];
    };
  };
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
    NIXOS_OZONE_WL = "1";
  };
  services.pcscd.enable = true;
  programs.ssh.startAgent = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    easyeffects
    kio-fuse

    chromium
    nyxt
    obsidian
    vscode
    telegram-desktop
    strawberry
    haruna

    gnome.nautilus
    shotwell
    nomacs

    # sway
    rofi-wayland
    pamixer
    waybar
    font-awesome
    brightnessctl
    playerctl
    wezterm
    gamescope
  ];
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.blueman.enable = true;

  services.fwupd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
