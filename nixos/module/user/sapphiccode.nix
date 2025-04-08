{pkgs, ...}: {
  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    extraGroups = ["wheel" "networkmanager" "input" "lp" "scanner" "dialout" "incus-admin"];
    shell = pkgs.bash;
  };
  programs.fish.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["sapphiccode"];
}
