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
    home.file.".config/hypr".source = ./config/hypr;
    home.file.".config/waybar".source = ./config/waybar;
    home.file.".config/foot".source = ./config/foot;


    home.pointerCursor = {
	gtk.enable = true;
	x11.enable = true;
	package = pkgs.bibata-cursors;
	name = "Bibata-Modern-Classic";
	size = 16;
    };
}
