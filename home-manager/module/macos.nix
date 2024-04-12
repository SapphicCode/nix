{pkgs, ...}: {
  home.packages = with pkgs; [
    bash
    coreutils
    curl
    gnugrep
    gnused
    lima
  ];
}
