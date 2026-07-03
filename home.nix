{ config, pkgs, ... }:

{
  home.username = "thedrituss";
  home.homeDirectory = "/home/thedrituss";
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      drtss = "echo drtss";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;

    #enableDefaultConfig = false;

    settings = {
      "oracle" = {
        HostName = "141.253.192.86";
        User = "opc";
        IdentityFile = "~/.ssh/oracle_cloud.key";
        ServerAliveInterval = "60";
      };
    };
  };

  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/foot".source = ./config/foot;
  #home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/thedrituss/nixos-files/config/nvim";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  home.packages = with pkgs; [
    google-antigravity-cli
  ];
}
