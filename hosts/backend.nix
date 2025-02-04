{ pkgs, lib, self, ... }:

let backendPort = "3000";
in {
  # Setting up a systemd unit running the go backend.
  systemd.services.backend = {
    description = "example go backend";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Environment = "PORT=" + backendPort;
      Type = "simple";
      DynamicUser = true;
      ExecStart = lib.getExe self.packages.${pkgs.system}.backend;
    };
  };

  # Configuring `nginx` to do two things:
  #
  # 1. Serve the frontend bundle on /.
  # 2. Proxy to the backend on /api.
  services.nginx = {
    # This switches on nginx.
    enable = true;
    # Enabling some good defaults.
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts."default" = {
      # Proxying to the backend on /api.
      locations."/api".proxyPass = "http://localhost:${backendPort}/";
    };
  };

  # We open just the http default port in the firewall. SSL termination happens
  # automatically on garnix's side.
  networking.firewall.allowedTCPPorts = [ 80 ];
}
