{pkgs, ...}: {
  imports = [
    ./comfortable.nix
  ];

  home.packages =
    import ../../pkgset/50-everything.nix {
      inherit pkgs;
    }
    ++ [
      # create a shell alias for kubectx -> kubeswitch
      (pkgs.writeShellApplication {
        name = "kubectx";
        runtimeInputs = [pkgs.kubeswitch];
        text = ''
          exec ${pkgs.kubeswitch.meta.mainProgram} "$@"
        '';
      })
    ];
}
