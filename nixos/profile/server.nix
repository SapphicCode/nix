{
  lib,
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ../module/openssh.nix
    ../module/tailscale.nix
    ../module/user/sapphiccode.nix
    ../module/user/automata.nix
    ../module/podman.nix
    ../module/podman-user-quadlet.nix
    ../module/packages.nix
  ];

  # Hardware > Boot
  boot.initrd.systemd.enable = true;

  # Hardware > Memory
  zramSwap.enable = true;
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
  };

  # Hardware > Networking
  services.resolved.enable = lib.mkDefault true;

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
  services.telegraf.enable = lib.mkDefault true;
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
    enable = lib.mkDefault true;
    journaldAccess = true;
    settings = {
      sources = {
        journal = {
          type = "journald";
        };
        # kubernetes = {
        #   type = "kubernetes_logs";
        #   self_node_name = config.networking.hostName;
        #   kube_config_file = "/etc/rancher/k3s/k3s.yaml";
        # };
      };
      transforms = {
        journal_std = {
          type = "remap";
          inputs = ["journal"];
          source = ''
            ._stream = encode_logfmt({"host": .host, "syslog_id": .SYSLOG_IDENTIFIER, "systemd_slice": ._SYSTEMD_SLICE})
          '';
        };
        # kubernetes_std = {
        #   type = "remap";
        #   inputs = ["kubernetes"];
        #   source = ''
        #     ._stream = encode_logfmt({"namespace": .kubernetes.pod_namespace, "pod": .kubernetes.pod_name, "container": .kubernetes.container_name})
        #     .host = .kubernetes.pod_node_name
        #   '';
        # };
      };
      sinks = {
        victorialogs_journal = {
          type = "http";
          inputs = ["journal_std"];
          encoding = {
            codec = "json";
          };
          framing = {
            method = "newline_delimited";
          };
          compression = "gzip";
          uri = "http://100.67.28.115:9428/insert/jsonline?_msg_field=message&_time_field=timestamp&_stream_fields=_stream";
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
        --one-file-system \
        --exclude-caches \
        --exclude-file $generated_excludes \
        --exclude /var/lib/containers/storage/overlay \
        --exclude /var/lib/rancher/k3s/agent/containerd \
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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05";
}
