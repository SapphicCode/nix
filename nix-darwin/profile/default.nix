{
  pkgs,
  unstable,
  ...
}: {
  nix.package = unstable.lixPackageSets.latest.lix;
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
