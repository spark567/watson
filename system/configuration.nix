# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  # config,
  # lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./network.nix
    ./services.nix
  ];

  # Enable zram (compressed ram)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Add a swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
      ];
      auto-optimise-store = true;
      use-xdg-base-directories = true;
    };

    # Automatically clean up old generations every week
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  boot = {
    enableContainers = true;
    kernelModules = [ ];

    kernel.sysctl = {
      # https://wiki.archlinux.org/title/Sysctl#Enable_TCP_Fast_Open
      "net.ipv4.tcp_fastopen" = 3;
    };

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        editor = true;
      };
    };

    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];
  };

  time.timeZone = "Europe/Berlin"; # Set your time zone.
  i18n.defaultLocale = "en_US.UTF-8"; # Select internationalisation properties.

  environment = {
    defaultPackages = [ ]; # Disable any default installed packages

    systemPackages = with pkgs; [
      fastfetch
      wget
      btop
      dysk
      git
      unzip
      zip
      lsof # A nicer alternative to netstat
      jq
    ];
  };

  fonts.fontconfig.enable = false;

  system = {
    stateVersion = "25.05";
    tools = {
      nixos-version.enable = true;
      nixos-rebuild.enable = true;
      nixos-option.enable = true;

      nixos-generate-config.enable = false;
      nixos-install.enable = false;
      nixos-build-vms.enable = false;
    };
  };

  programs = {
    nano.enable = true;
    fish.enable = true;
    bat.enable = true; # Enable bat, a nicer alternative to cat
  };

  security = {
    # lockKernelModules = true;
    protectKernelImage = true;

    # use sudo-rs instead of sudo
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
    };

    # Enable this if you want docker to bind to ports lower than 1024
    wrappers = {
      docker-rootlesskit = {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service+ep";
        source = "${pkgs.rootlesskit}/bin/rootlesskit";
      };
    };
  };

  virtualisation = {
    docker = {
      enable = false;
      rootless = {
        enable = true;
        setSocketVariable = true;

        daemon.settings = {
          dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          registry-mirrors = [
            "https://docker.io"
            "https://mirror.gcr.io"
          ];
        };
      };
    };
  };

  users = {
    groups.cruise = { };
    users = {
      cruise = {
        isNormalUser = true;
        linger = true;
        group = "cruise";
        extraGroups = [ ];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiRKJiC+keGpcnWC9vItrPGqYSq9+bK3pNWc+zgnrMR user@radcliffe"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL2za6psnuIMZ6FrdUehhyQlqYvy05+wv8dKER+Lctna snowy@Snowflake"
        ];
      };

      root = {
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiRKJiC+keGpcnWC9vItrPGqYSq9+bK3pNWc+zgnrMR user@radcliffe"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL2za6psnuIMZ6FrdUehhyQlqYvy05+wv8dKER+Lctna snowy@Snowflake"
        ];
      };
    };
  };
}
