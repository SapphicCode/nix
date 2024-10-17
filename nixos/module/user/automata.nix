{
  pkgs,
  config,
  ...
}: {
  users.users.automata = {
    isSystemUser = true;
    group = "wheel";
    description = "CI system user";
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTeL+/pRmboNs+wga7IZ4OkgCcUN9rwC8mjTi3b9yKU"
    ];
  };
  security.sudo.extraRules = [
    {
      users = [config.users.users.automata.name];
      commands = ["NOPASSWD:ALL"];
    }
  ];
}
