{ config, pkgs, ... }:

{
  home.username = "thedrituss";
  home.homeDirectory = "/home/thedrituss";
  home.stateVersion = "26.05";

  # =========================================================================
  # BASH (Login manual desde TTY)
  # =========================================================================
  programs.bash = {
    enable = true;
    shellAliases = {
      drtss = "echo drtss";
      # Alias cómodo para iniciar Niri tecleando solo 'niri' tras el login
      niri = "niri-session";
    };
  };

  # =========================================================================
  # UTILIDADES Y HERRAMIENTAS
  # =========================================================================
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    settings = {
      "oracle" = {
        HostName = "79.72.51.211";
        User = "opc";
        IdentityFile = "~/.ssh/oracle.key";
        ServerAliveInterval = "60";
      };
    };
  };

  # =========================================================================
  # DOTFILES / CONFIGURACIONES
  # =========================================================================
  # Sustituido Hyprland por Niri (apunta a la carpeta config/niri de tu repo)
  home.file.".config/niri".source = ./config/niri;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/foot".source = ./config/foot;

  # Enlace dinámico a Neovim
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/thedrituss/nixos-files/config/nvim";

  home.file.".config/vis".source =
    config.lib.file.mkOutOfStoreSymlink "/home/thedrituss/nixos-files/config/vis";
  # =========================================================================
  # TEMA DE CURSOR (Compatible con Wayland y X11/XWayland)
  # =========================================================================
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 10;
  };

  # Paquetes a nivel de usuario
  home.packages = with pkgs; [
    google-antigravity
    google-antigravity-ide
    google-antigravity-cli
  ];

}
