{pkgs, ...}: {
  environment.etc = {
    "containers/systemd/sapphiccode.network".source = ./containers/sapphiccode.network;

    # Web services
    "containers/systemd/sapphiccode-cloudflare.container".source = ./containers/sapphiccode-cloudflare.container;
    "containers/systemd/sapphiccode-forgejo.container".source = ./containers/sapphiccode-forgejo.container;
    "containers/systemd/sapphiccode-uptimekuma.container".source = ./containers/sapphiccode-uptimekuma.container;

    # CI/CD for Forgejo
    "containers/systemd/sapphiccode-woodpecker-server.container".source = ./containers/sapphiccode-woodpecker-server.container;
    "containers/systemd/sapphiccode-woodpecker-agent.container".source = ./containers/sapphiccode-woodpecker-agent.container;

    # Databases
    "containers/systemd/sapphiccode-postgres.container".source = ./containers/sapphiccode-postgres.container;
    "containers/systemd/sapphiccode-victorialogs.container".source = ./containers/sapphiccode-victorialogs.container;
    "containers/systemd/sapphiccode-victoriametrics.container".source = ./containers/sapphiccode-victoriametrics.container;
  };

  system.activationScripts.testQuadlets = {
    deps = [];
    text = ''
      if [ "$NIXOS_ACTION" = "switch" ]; then
        target=$(mktemp -d)
        ${pkgs.podman}/lib/systemd/system-generators/podman-system-generator "$target"
        rm -r "$target"
      fi
    '';
  };
}
