{lib, ...}: {
  services.k3s.enable = lib.mkDefault true;

  # prevent k3s from using host search domains
  services.k3s.extraFlags = ["--resolv-conf=/etc/resolv.k3s.conf"];
  environment.etc."resolv.k3s.conf".text = ''
    nameserver 1.1.1.1
    nameserver 1.0.0.1
  '';
}
