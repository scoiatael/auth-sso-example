{ pkgs, lib, self, ... }:

{
  services.nginx = {
    # This switches on nginx.
    enable = true;
    # Enabling some good defaults.
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts."default" = {
      # Serving the frontend bundle by default.
      locations."/".root = "${self.packages.${pkgs.system}.frontend-bundle}";
    };
  };

  # We open just the http default port in the firewall. SSL termination happens
  # automatically on garnix's side.
  networking.firewall.allowedTCPPorts = [ 80 ];
}
