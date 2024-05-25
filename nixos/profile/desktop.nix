{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../module/user/sapphiccode.nix
    ../module/packages.nix
    ../module/tailscale.nix
    ../module/aarch64-fixes.nix
  ];

  # Hardware > Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  # Kernel > Memory deadlocks
  systemd.watchdog.runtimeTime = "20s";
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
  };
  zramSwap.enable = true;

  # Hardware > Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = ["lo" "tailscale*"];
  services.resolved.enable = true;

  # Hardware > Fingerprints
  services.fprintd.enable = false;
  security.pam.services.login.fprintAuth = false;
  security.pam.services.xrdp-sesman.fprintAuth = false;

  # Hardware > Miscellaneous
  services.pcscd.enable = true;
  services.fwupd.enable = true;
  hardware.keyboard.qmk.enable = true;

  # Hardware > Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Hardware > Printing
  services.avahi.enable = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
    epson-escpr2
  ];

  # Hardware > Scanning
  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [
    epsonscan2
  ];

  # Regional
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_IE.UTF-8";

  # Security
  security.pam.services.sudo.nodelay = true;
  security.pam.services.sudo.failDelay = {
    enable = true;
    delay = 300000;
  };

  # Graphical
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # programs.sway = {
  #   enable = true;
  #   package = unstable.swayfx.override {withBaseWrapper = true;};
  # };
  services.xserver.displayManager.defaultSession = "plasmawayland";

  # Extra packages
  environment.systemPackages = with pkgs; [
    # web:
    firefox
    vivaldi
    chromium
    thorium-browser

    # chat:
    telegram-desktop
    signal-desktop

    # writing:
    obsidian
    vscode
    libreoffice-fresh

    # media:
    strawberry
    haruna

    # fun:
    prismlauncher
    sunvox

    # utility:
    gnome.simple-scan
    krename
    easyeffects
    mkvtoolnix

    # sway:
    # rofi-wayland
    # pamixer
    # waybar
    # font-awesome
    # brightnessctl
    # playerctl
    # wezterm

    # fonts:
    fira-code
    fira-code-nerdfont
  ];

  # Program hooks
  programs.ccache.enable = true;
  nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];
  programs.gnupg.agent.enable = true;
  programs.ssh.startAgent = true;
  programs._1password-gui.enable = true;
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      vivaldi-bin
    '';
    mode = "0644";
  };
  programs.kdeconnect.enable = true;
  programs.steam = {
    enable = true;
    # package = pkgs.steam.override {
    #   extraEnv = {};
    #   extraLibraries = pkgs:
    #     with pkgs; [
    #       xorg.libXcursor
    #       xorg.libXi
    #       xorg.libXinerama
    #       xorg.libXScrnSaver
    #       libpng
    #       libpulseaudio
    #       libvorbis
    #       stdenv.cc.cc.lib
    #       libkrb5
    #       keyutils
    #       gamescope
    #     ];
    # };
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  programs.nix-ld.enable = true;

  # Background maintenance tasks
  services.zfs.trim.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  system.stateVersion = "23.11";
}
