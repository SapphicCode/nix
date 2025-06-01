{pkgs, ...}: {
  users.users.aurelia = {
    isNormalUser = true;
    description = "Aurelia";
    extraGroups = ["wheel" "networkmanager" "input" "lp" "scanner" "dialout"];
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q"
    ];
  };
  programs.fish.enable = true;
  nix.settings.trustedUsers = ["aurelia"];
  programs._1password-gui.polkitPolicyOwners = ["aurelia"];
}
