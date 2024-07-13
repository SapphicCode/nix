{pkgs, ...}: {
  users.users.hex = {
    isNormalUser = true;
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
}
