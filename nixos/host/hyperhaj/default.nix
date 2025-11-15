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
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # unblock port 22
  services.openssh.ports = [2222];

  # do NAT
  networking.nftables = {
    enable = true;
    ruleset = ''
      table ip nat {
        chain PREROUTING {
          type nat hook prerouting priority dstnat; policy accept;
          ip daddr 37.27.111.226 tcp dport 22 dnat ip to 10.75.0.115:22
          ip daddr 37.27.111.226 tcp dport 80 dnat ip to 10.75.1.60:80
          ip daddr 37.27.111.226 tcp dport 443 dnat ip to 10.75.1.60:443
        }
        chain POSTROUTING {
          type nat hook postrouting priority srcnat; policy accept;
          oifname "en*" masquerade
          oifname "incusbr*" ct status dnat masquerade
        }
      }
    '';
  };

  # block incus until ZFS is unlocked
  systemd = {
    services.zfs-key-hyperhaj-incus = {
      unitConfig = {
        Description = "Wait for ZFS dataset hyperhaj/incus to be unlocked";
        After = ["zfs-import.target"];
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
      # restart incus on system updates (won't restart VMs but will fix networking)
      restartTriggers = [config.system.build.toplevel];
    };
  };
}
