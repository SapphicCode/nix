{pkgs, ...}: {
  users.users.chaos = {
    isNormalUser = true;
    uid = 1666;
    shell = "/home/chaos/.nix-profile/bin/zsh";
  };
}
