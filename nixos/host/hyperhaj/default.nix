{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../module/systemd-boot.nix
    ../../profile/server_x86_64-linux.nix
    ../../module/systemd-networkd-en_dhcp.nix
    ../../module/incus.nix
  ];

  networking.hostName = "hyperhaj";
  networking.hostId = "ef6c5017";
  networking.firewall.enable = false;
  zramSwap.enable = false;
  hardware.ksm.enable = true;

  # unblock port 22
  services.openssh.ports = [2222];

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  # do NAT & firewalling
  networking.nftables = {
    enable = true;
    ruleset = ''
      table ip nat {
        chain PREROUTING {
          type nat hook prerouting priority dstnat; policy accept;
          ip daddr 37.27.111.226 tcp dport 22 dnat ip to 10.75.0.115:22
          ip daddr 37.27.111.226 tcp dport 80 dnat ip to 10.75.1.170:80
          ip daddr 37.27.111.226 tcp dport 443 dnat ip to 10.75.1.170:443
        }
        chain POSTROUTING {
          type nat hook postrouting priority srcnat; policy accept;
          ip saddr { 10.75.0.0/16 } ip daddr { 10.75.0.0/16 } masquerade
          oifname "wg*" masquerade
          oifname "en*" masquerade
        }
        chain output {
          type nat hook output priority -100; policy accept;

          # enable host to access services in k8s via public IP
          ip daddr 37.27.111.226 tcp dport { 80, 443 } dnat to 10.75.1.170
        }
      }

      table ip filter {
        chain forward {
          type filter hook forward priority filter; policy accept;

          # allow return traffic
          ct state established,related counter accept

          # filter private ranges so Hetzner's security team doesn't go nuclear on us
          oifname "en*" ip daddr {
            10.0.0.0/8,
            172.16.0.0/12,
            192.168.0.0/16,
            100.64.0.0/10
          } counter drop

          # allow DNAT
          iifname "en*" ip daddr 10.75.0.115 tcp dport 22 counter accept
          iifname "en*" ip daddr 10.75.1.170 tcp dport { 80, 443 } counter accept

          # block all other forwarding
          iifname "en*" counter drop
        }
      }
    '';
  };

  services.udev.extraRules = ''
    # Enable hairpin mode when a new tap interface is added to any incusbr* bridge
    SUBSYSTEM=="net", ACTION=="add", KERNEL=="tap*", RUN+="${pkgs.writeShellScript "enable-hairpin" ''
      sleep 0.5
      bridge=$(basename $(readlink /sys/class/net/$1/brport/bridge 2>/dev/null) 2>/dev/null)
      if [[ $bridge == incusbr* ]]; then
        echo 1 > /sys/class/net/$1/brport/hairpin_mode
      fi
    ''} %k"
  '';

  # set routes for incusbr2
  networking.iproute2 = {
    enable = true;
    rttablesExtraConfig = ''
      200 wgtun
    '';
  };
  networking.wg-quick.interfaces.wg0 = {
    configFile = "/etc/secrets/vpn/fi-hel-fi1.conf";
    # remember to do Table = "off" in the Interface section!
  };
  systemd.services.network-set-up-wgtun = {
    wants = ["wg-quick-wg0.service"];
    after = ["wg-quick-wg0.service"];
    wantedBy = ["multi-user.target"];
    unitConfig.Type = "oneshot";
    script = ''
      ${pkgs.iproute2}/bin/ip rule add iif incusbr2 table wgtun priority 100 || true
      ${pkgs.iproute2}/bin/ip route add default dev wg0 table wgtun || true
    '';
  };

  # block incus until ZFS is unlocked
  boot.zfs.requestEncryptionCredentials = false;
  systemd = {
    services.zfs-key-hyperhaj-incus = {
      unitConfig = {
        Description = "Wait for ZFS dataset hyperhaj/incus to be unlocked";
        After = ["zfs-import.target" "sshd.service"];
        Before = ["zfs-key-hyperhaj-incus.target"];
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutSec = "infinity";
      };
      script = ''
        #!${pkgs.bash}/bin/bash
        while [ "''$(${config.boot.zfs.package}/bin/zfs get -H -o value keystatus hyperhaj/incus)" != "available" ];
          do sleep 1;
        done
        echo "Detected unlock."
      '';
    };

    targets.zfs-key-hyperhaj-incus.unitConfig = {
      Description = "ZFS dataset hyperhaj/incus is unlocked";
      Requires = ["zfs-key-hyperhaj-incus.service"];
      After = ["zfs-key-hyperhaj-incus.service"];
    };

    services.incus = {
      unitConfig = {
        Requires = ["zfs-key-hyperhaj-incus.target"];
        After = ["zfs-key-hyperhaj-incus.target"];
      };
      restartTriggers = [config.networking.nftables.ruleset];
      stopIfChanged = false; # otherwise VMs will reboot
    };
  };
}
