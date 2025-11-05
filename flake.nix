{
  description = "Watson` Server Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      ... # Passes all arguments in inputs without having to specify them
    }@inputs:

    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.watson = inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        # Any arugments we want our config files to have (like configuration.nix)
        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./system/configuration.nix
          "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix" # Disables some options by default for a minimal installation: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/minimal.nix

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs; # Makes sure we have access to inputs in our home-manager configs.
            };
            home-manager.users = {
              # All users managed by home-manager :3
              cruise = import ./home-manager/cruise.nix;
            };
          }
        ];
      };
    };
}
