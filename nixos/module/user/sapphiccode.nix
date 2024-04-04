{pkgs, ...}: {
  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    extraGroups = ["wheel" "networkmanager" "input" "lp" "scanner"];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["sapphiccode"];
}
