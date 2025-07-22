{pkgs, ...}: {
  systemd.services.restic = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    script = ''
      set -euxo pipefail

      generated_excludes=$(mktemp)
      ${pkgs.fd}/bin/fd --absolute-path --hidden --full-path 'containers/storage/volumes/([0-9a-f]{64}|\w+_cache)$' /var/lib /home > $generated_excludes

      ${pkgs.restic}/bin/restic backup \
        --one-file-system \
        --exclude-caches \
        --exclude-file $generated_excludes \
        --exclude /var/lib/containers/storage/overlay \
        --exclude /var/lib/rancher/k3s/agent/containerd \
        --exclude '/home/*/.local/share/containers/storage/overlay' \
        --exclude '/home/*/.cache' \
        --exclude '/home/*/Downloads' \
        /etc \
        /home \
        /var/lib
    '';
    serviceConfig.EnvironmentFile = "/etc/creds/restic.env";
    serviceConfig.Environment = "HOME=%h";
  };
  systemd.timers.restic = {
    timerConfig.OnStartupSec = "15m";
    timerConfig.OnUnitActiveSec = "1h";
    wantedBy = ["timers.target"];
  };
}
