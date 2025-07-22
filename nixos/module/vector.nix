{lib, ...}: {
  services.vector = {
    enable = lib.mkDefault true;
    journaldAccess = true;
    settings = {
      sources = {
        journal = {
          type = "journald";
        };
        # kubernetes = {
        #   type = "kubernetes_logs";
        #   self_node_name = config.networking.hostName;
        #   kube_config_file = "/etc/rancher/k3s/k3s.yaml";
        # };
      };
      transforms = {
        journal_std = {
          type = "remap";
          inputs = ["journal"];
          source = ''
            ._stream = encode_logfmt({"host": .host, "syslog_id": .SYSLOG_IDENTIFIER, "systemd_slice": ._SYSTEMD_SLICE})
          '';
        };
        # kubernetes_std = {
        #   type = "remap";
        #   inputs = ["kubernetes"];
        #   source = ''
        #     ._stream = encode_logfmt({"namespace": .kubernetes.pod_namespace, "pod": .kubernetes.pod_name, "container": .kubernetes.container_name})
        #     .host = .kubernetes.pod_node_name
        #   '';
        # };
      };
      sinks = {
        victorialogs_journal = {
          type = "http";
          inputs = ["journal_std"];
          encoding = {
            codec = "json";
          };
          framing = {
            method = "newline_delimited";
          };
          compression = "gzip";
          uri = "http://100.67.28.115:9428/insert/jsonline?_msg_field=message&_time_field=timestamp&_stream_fields=_stream";
        };
      };
    };
  };
  systemd.services.vector = {
    wants = ["tailscaled.service"];
    after = ["tailscaled.service"];
  };
}
