{pkgs, ...}: {
  environment.etc = {
    "containers/systemd/sapphiccode.network".source = ./containers/sapphiccode.network;
    "containers/systemd/sapphiccode-mariadb.network".source = ./containers/sapphiccode.network;

    # Web services
    "containers/systemd/sapphiccode-cloudflare.container".source = ./containers/sapphiccode-cloudflare.container;
    "containers/systemd/sapphiccode-uptimekuma.container".source = ./containers/sapphiccode-uptimekuma.container;
    "containers/systemd/sapphiccode-pufferpanel.container".source = ./containers/sapphiccode-pufferpanel.container;
    "containers/systemd/sapphiccode-archivebox.container".source = ./containers/sapphiccode-archivebox.container;
    "containers/systemd/sapphiccode-bookstack.container".source = ./containers/sapphiccode-bookstack.container;
    "containers/systemd/sapphiccode-nextcloud.container".source = ./containers/sapphiccode-nextcloud.container;
    "containers/systemd/sapphiccode-attic.container".source = ./containers/sapphiccode-attic.container;

    # CI/CD for Forgejo
    "containers/systemd/sapphiccode-woodpecker-server.container".source = ./containers/sapphiccode-woodpecker-server.container;
    "containers/systemd/sapphiccode-woodpecker-agent.container".source = ./containers/sapphiccode-woodpecker-agent.container;

    # Databases
    "containers/systemd/sapphiccode-postgres.container".source = ./containers/sapphiccode-postgres.container;
    "containers/systemd/sapphiccode-mariadb.container".source = ./containers/sapphiccode-mariadb.container;
    "containers/systemd/sapphiccode-mongodb.container".source = ./containers/sapphiccode-mongodb.container;
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
