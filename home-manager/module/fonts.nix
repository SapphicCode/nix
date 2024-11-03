{pkgs, ...}: {
  home.packages = with pkgs; [
    fira
    ibm-plex
    merriweather

    fira-code
    fira-code-nerdfont
    iosevka
    iosevka-comfy.comfy
  ];
}
