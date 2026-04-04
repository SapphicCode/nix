{lib, ...}: {
  services.telegraf.enable = lib.mkDefault true;
  services.telegraf.extraConfig = {
    inputs = {
      cpu = {report_active = true;};
      mem = {};
      disk = {ignore_fs = ["tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs" "efivarfs"];};
      net = {interfaces = ["en*"];};
      system = {};
      kernel = {
        collect = ["ksm" "psi"];
      };
    };
    outputs = {
      influxdb = {
        urls = ["http://100.126.72.79:8428"];
      };
    };
  };
  systemd.services.telegraf.wants = ["tailscaled.service"];
  systemd.services.telegraf.after = ["tailscaled.service"];
}
