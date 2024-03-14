{pkgs, ...}: {
  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    extraGroups = ["wheel" "networkmanager" "input"];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["sapphiccode"];
}
