{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password
    bashInteractive
    curl
    gnugrep
    gnused
    lima
    qemu # podman machine
    uutils-coreutils-noprefix
  ];
}
