{
  config,
  pkgs,
  ...
}: {
  environment.etc =
    if config.virtualisation.podman.enable
    then {
      "systemd/user-generators/podman-user-generator" = {
        source = "${pkgs.podman}/lib/systemd/user-generators/podman-user-generator";
        target = "systemd/user-generators/podman-user-generator";
      };
    }
    else {};
}
