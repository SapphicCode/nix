{
  lib,
  rootDevice ? "/dev/disk/by-partlabel/root",
  encrypted ? true,
  encryptedPartition ? rootDevice,
}: {
  # This module defines a generic hardware configuration for a VM.

  imports = [
    ./vm-guest.nix
  ];

  disko.devices = {
    disk.main = {
      device = rootDevice;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          "ESP" = {
            type = "EF00";
            size = "4G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };

            "root" = {
              type = "8300";
              size = "100%";
              content = {
                type = "luks";
                name = "luks-system";
                extraOpenArgs = ["--persistent" "--allow-discards"];

                content = {
                  type = "zfs";
                  pool = "rpool";
                };
              };
            };
          };
        };
      };
    };

    zpool.rpool = {
      type = "zpool";
      options.ashift = "12";
      rootFsOptions = {
        mountpoint = "none";
        compression = "zstd";
        acltype = "posixacl";
        xattr = "sa";
      };
      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
          options.mountpoint = "legacy";
        };
        "nix-store" = {
          type = "zfs_fs";
          mountpoint = "/nix/store";
          options.mountpoint = "legacy";
        };
        var = {
          type = "zfs_fs";
          mountpoint = "/var";
          options.mountpoint = "legacy";
        };
        tmp = {
          type = "zfs_fs";
          mountpoint = "/tmp";
          options.mountpoint = "legacy";
        };
        home = {
          type = "zfs_fs";
          mountpoint = "/home";
          options.mountpoint = "legacy";
        };
        "home-root" = {
          type = "zfs_fs";
          mountpoint = "/root";
          options.mountpoint = "legacy";
        };
      };
    };
  };
  boot.initrd.luks.devices."luks-system".device = lib.mkIf encrypted encryptedPartition;

  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
      options = ["ro"];
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
      options = ["rw"];
    };
    # cover all our variable filesystems
    "/nix/store" = {
      device = "rpool/nix-store";
      fsType = "zfs";
    };
    "/var" = {
      device = "rpool/var";
      fsType = "zfs";
    };
    "/tmp" = {
      device = "rpool/tmp";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };
    "/root" = {
      device = "rpool/home-root";
      fsType = "zfs";
    };
  };
}
