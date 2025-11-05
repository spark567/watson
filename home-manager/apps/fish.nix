{ ... }:
{
  programs.fish = {
    enable = true;
    generateCompletions = true;

    shellAliases = {
      ls = "eza -ihg --icons";

      cat = "/run/current-system/sw/bin/bat";
      bat = "/run/current-system/sw/bin/cat";

      myip = "curl https://ipinfo.io/ip";
      myip6 = "curl https://v6.ipinfo.io/ip";

      docres = "docker compose down && docker compose up -d";
      docvol = "cd ~/.local/share/docker/volumes";

      logboot = "journalctl --boot=-1 --reverse";
      listgens = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
    };

    shellInit = ''
      if status is-interactive
        set -xg fish_color_command blue
        echo "Welcome to $(whoami)@$(hostname)!"
        echo ""
        fastfetch
        echo ""
      end
    '';
  };
}
