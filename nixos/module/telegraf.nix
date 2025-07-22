{lib, ...}: {
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
}
