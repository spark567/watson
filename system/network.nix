{ ... }:
{
  networking = {
    hostName = "watson";

    # Some good default dns servers
    nameservers = [
      # Cloudflare
      "2606:4700:4700::1111"
      "1.1.1.1"
      "2606:4700:4700::1001"
      "1.0.0.1"

      # Mullvad
      "2a07:e340::2"
      "194.242.2.2"
    ];

    # Use more modern nftables instead of iptables
    # nftables.enable = true;

    # # Gateways, these are specified in netcup
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };

    interfaces = {
      ens3 = {
        ipv6.addresses = [
          {
            # Based on ipv6 block allocated in netcup
            address = "2a0a:4cc0:2000:c47f::";
            prefixLength = 64;
          }
        ];
        # ipv4.addresses = [
        #   {
        #     # Based on ipv4 allocated in netcup
        #     address = "152.53.210.248";
        #     prefixLength = 22;
        #   }
        # ];
      };
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [
        # HTTP
        80
        443

        # ssh
        22

        25566 # Runevale prod
        25567 # Runevale staging
        
        25576 # Runevale prod rcon
        25577 # Runevale staging rcon

        41448 # Simple Voice Chat prod
        41449 # Simple Voice Chat staging

        8100 # Bluemap prod
        8101 # Bluemap staging

        # Pyrodactyl
        8080
        8090 # Elytra
      ];

      allowedUDPPorts = [
        # HTTP3
        80
        443

        # mc
        24454 # simple voice chat

        41448
        8100
      ];
    };

  };
}
