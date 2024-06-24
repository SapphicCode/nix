{pkgs, ...}: {
  users.users.aurelia = {
    isNormalUser = true;
    description = "Aurelia";
    extraGroups = ["wheel" "networkmanager" "input" "lp" "scanner" "dialout"];
    shell = pkgs.bash;
  };
  programs.fish.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["aurelia"];
}
