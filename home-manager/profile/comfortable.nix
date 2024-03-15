{pkgs, ...}: {
  imports = [
    ./minimal.nix
  ];

  home.packages = with pkgs; [
    nushell # crazy powerful shell

    # shell plugins
    zoxide

    # fancier TUIs
    btop

    # neovim soft dependencies
    efm-langserver
    fzf
    ripgrep

    # containers
    podman
    docker-client
    docker-compose
    distrobox

    # tools
    hyfetch
    restic
    gnupg
    fq
    just
    ## avoid conflict with go-task
    (writeShellScriptBin "taskw" ''
      exec "${pkgs.taskwarrior}/bin/task" "$@"
    '')
  ];
}
