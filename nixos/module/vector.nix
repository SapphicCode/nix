{lib, ...}: {
  services.vector = {
    enable = lib.mkDefault true;
    journaldAccess = true;
    settings = {
      sources = {
        journal = {
          type = "journald";
        };
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
          uri = "http://100.126.72.79:9428/insert/jsonline?_msg_field=message&_time_field=timestamp&_stream_fields=host,SYSLOG_IDENTIFIER,_SYSTEMD_SLICE";
        };
      };
    };
  };
  systemd.services.vector = {
    wants = ["tailscaled.service"];
    after = ["tailscaled.service"];
  };
}
