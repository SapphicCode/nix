{
  pkgs,
  fallback ? pkgs,
}:
with pkgs;
  [
    nushell # crazy powerful shell

    # git
    mergiraf

    # shell plugins
    zoxide
    #atuin

    # fancier TUIs
    btop

    # neovim soft dependencies
    efm-langserver
    fzf
    ripgrep
    gcc

    # containers
    podman
    docker-client
    docker-compose

    # tools
    hyfetch
    restic
    gnupg
    fq
    just
    halp
    gum
    devbox
  ]
  ++ (
    if pkgs.stdenv.isDarwin
    then [fallback.numbat]
    else [pkgs.numbat]
  )
