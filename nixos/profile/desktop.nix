{
  pkgs,
  unstable,
  lib,
  config,
  ...
}: {
  imports = [
    ../module/user/sapphiccode.nix
    ../module/packages.nix
    ../module/tailscale.nix
    ../module/openssh.nix
    ../module/podman-user-quadlet.nix
    ../module/printing.nix
    ../module/distbuild-blahaj.nix
  ];
  # Hardware > Boot
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
  services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = false;
  security.pam.services.xrdp-sesman.fprintAuth = false;

  # Hardware > Miscellaneous
  services.pcscd.enable = true;
  services.fwupd.enable = true;
  hardware.keyboard.qmk.enable = true;

  # Hardware > Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Hardware > Graphics
  environment.sessionVariables."MOZ_ENABLE_WAYLAND" = "1";

  # Hardware > Scanning
  hardware.sane.enable = true;

  # Regional
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_IE.UTF-8";

  # Security
  security.pam.services.sudo.nodelay = true;
  security.pam.services.sudo.failDelay = {
    enable = true;
    delay = 200000;
  };

  # programs.sway = {
  #   enable = true;
  #   package = unstable.swayfx.override {withBaseWrapper = true;};
  # };
  # services.displayManager.defaultSession = "plasmawayland";

  # Extra packages
  environment.systemPackages = with pkgs;
    [
      # web:
      chromium

      # chat:
      telegram-desktop
      signal-desktop

      # writing:
      obsidian
      vscode
      unstable.zed-editor
      libreoffice-fresh

      # media:
      strawberry
      haruna
      mpv
      obs-studio
      kdenlive

      # fun:
      prismlauncher
      gamescope
      unstable.lmstudio
      unstable.qFlipper

      # utility:
      simple-scan
      krename
      easyeffects
      mkvtoolnix
      wezterm
      ghostty
      gitFull

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
    ]
    ++ import ../../pkgset/99-fonts.nix {inherit pkgs;};

  programs.firefox.enable = true;

  # Escape hatch
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Program hooks
  nix.package = unstable.lix;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.ccache.enable = true;
  nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];
  programs.gnupg.agent.enable = true;
  programs.ssh.startAgent = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      floorp
      vivaldi-bin
      zen
      zen-bin
    '';
    mode = "0644";
  };
  programs.kdeconnect.enable = true;
  services.mullvad-vpn.enable = true;
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  virtualisation.podman.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];
  };

  # Background maintenance tasks
  services.zfs.trim.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  system.stateVersion = "23.11";
}
