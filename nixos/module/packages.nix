{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gptfdisk
    cryptsetup
  ];
}
