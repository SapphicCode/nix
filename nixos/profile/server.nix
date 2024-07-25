{
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ../module/openssh.nix
    ../module/tailscale.nix
    ../module/user/sapphiccode.nix
    ../module/podman-user-quadlet.nix
  ];

  # Hardware > Memory
  zramSwap.enable = true;
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
  };

  # Hardware > Networking
  services.resolved.enable = true;

  # Hardware > Firmware
  services.fwupd.enable = true;

  # Security
  security.sudo.wheelNeedsPassword = false;

  # Software > Maintenance
  services.zfs.trim.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  # Software > Everyday
  nix.package = unstable.lix;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [];
  programs.gnupg.agent.enable = true;

  # Software > Metrics
  services.telegraf.enable = true;
  services.telegraf.extraConfig = {
    inputs = {
      cpu = {report_active = true;};
      mem = {};
      disk = {ignore_fs = ["tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs" "efivarfs"];};
      net = {interfaces = ["en*"];};
      system = {};
      ping = {
        urls = ["89.1.7.228"];
        method = "native";
        ping_interval = 0.5;
        count = 10;
      };
    };
    outputs = {
      influxdb = {
        urls = ["http://100.67.28.115:8428"];
      };
    };
  };
  systemd.services.telegraf.wants = ["tailscaled.service"];
  systemd.services.telegraf.after = ["tailscaled.service"];

  # Software > Logs
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        journal = {
          type = "journald";
        };
      };
      sinks = {
        victorialogs = {
          type = "http";
          inputs = ["journal"];
          encoding = {
            codec = "json";
          };
          framing = {
            method = "newline_delimited";
          };
          compression = "gzip";
          uri = "http://100.67.28.115:9428/insert/jsonline?_msg_field=message&_time_field=timestamp&_stream_fields=host,SYSLOG_IDENTIFIER,_SYSTEMD_SLICE";
        };
      };
    };
  };
  systemd.services.vector = {
    wants = ["tailscaled.service"];
    after = ["tailscaled.service"];
  };

  # Software > Backups
  systemd.services.restic = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    script = ''
    set -euxo pipefail

    generated_excludes=$(mktemp)
    ${pkgs.fd}/bin/fd --absolute-path --hidden --full-path 'containers/storage/volumes/([0-9a-f]{64}|\w+_cache)$' /var/lib /home > $generated_excludes

    ${pkgs.restic}/bin/restic backup \
      --exclude-caches \
      --exclude-file $generated_excludes \
      --exclude /var/lib/containers/storage/overlay \
      --exclude '/home/*/.local/share/containers/storage/overlay' \
      --exclude '/home/*/.cache' \
      --exclude '/home/*/Downloads' \
      /etc \
      /home \
      /var/lib
    '';
    serviceConfig.EnvironmentFile = "/etc/creds/restic.env";
    serviceConfig.Environment = "HOME=%h";
  };
  systemd.timers.restic = {
    timerConfig.OnStartupSec = "15m";
    timerConfig.OnUnitActiveSec = "1h";
    wantedBy = ["timers.target"];
  };

  # Software > Server stuff
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  networking.firewall.trustedInterfaces = ["podman+"];

  system.stateVersion = "24.05";
}
