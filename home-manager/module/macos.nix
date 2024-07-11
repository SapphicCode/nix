{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password
    bash
    curl
    gnugrep
    gnused
    lima
    qemu # podman machine
    uutils-coreutils-noprefix
  ];
}
