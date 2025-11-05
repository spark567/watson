{ pkgs, inputs, ... }:
{
  imports = [
    ./apps/fish.nix
  ];

  home = {
    stateVersion = "25.05";

    packages = with pkgs; [
      ctop
    ];
  };

  programs = {
    # enable eza, a more functional replacement of ls
    eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "always";
    };
  };
}
