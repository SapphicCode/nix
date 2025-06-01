{pkgs, ...}: {
  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    extraGroups = ["wheel" "networkmanager" "input" "lp" "scanner" "dialout" "video" "incus-admin"];
    shell = pkgs.bash;
  };
  programs.fish.enable = true;
  nix.settings.trustedUsers = ["sapphiccode"];
  programs._1password-gui.polkitPolicyOwners = ["sapphiccode"];
}
