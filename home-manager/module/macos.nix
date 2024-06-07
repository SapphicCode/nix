{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password
    bash
    coreutils
    curl
    gnugrep
    gnused
    lima
    qemu # podman machine
  ];
}
