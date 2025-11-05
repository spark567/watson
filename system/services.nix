{ config, ... }:
{
  services = {
    # openssh, lol
    openssh = {
      enable = true;
      ports = [
        22
      ];
      allowSFTP = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
      };
    };

    # Will need to do some debugging later
    # # A nice webserver that handles everything
    caddy = {
      enable = true;
      virtualHosts = {
        "runevale.cc" = {
          #serverAliases = [ "play.runevale.cc" ]; # Any extra aliases, optional
          extraConfig = ''
            encode gzip
            root * /home/cruise/websites/runevale
            # file_server
          '';
        };

        # Makes it so it reverse proxies to the bluemap on port 27112
        "map.runevale.cc" = {
          extraConfig = ''
            encode gzip
            reverse_proxy http://localhost:8100
          '';
        };

        "panel.runevale.cc" = {
          extraConfig = ''
            encode gzip
            reverse_proxy http://localhost:8010
          '';
        };

        "elytra.runevale.cc" = {
          extraConfig = ''
            encode gzip
            reverse_proxy http://localhost:8080
          '';
        };

        "dockge.runevale.cc" = {
          extraConfig = ''
            encode gzip
            reverse_proxy http://localhost:5001
          '';
        };
      };
    };
  };
}