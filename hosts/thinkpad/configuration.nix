{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    extraEntries = {
      "freebsd.conf" = ''
        title FreeBSD 15
        efi   /EFI/freebsd/loader.efi
        sort-key 2
      '';
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];


  #boot.kernelParams = [ "r8169.aspm=0" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "thinkpad";
  networking.wireless.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";

  #services.getty.autologinUser = "thedrituss";

  programs.niri.enable = true;

  services.udev.packages = [ pkgs.swayosd ];

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  console.keyMap = "es";

  users.users."thedrituss" = {
    isNormalUser = true;
    description = "thedrituss";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
    ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;

  # =========================================================================
  # Configuración de Spotify con Spicetify + Adblock
  # =========================================================================
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock # Bloqueador de anuncios integrado
      ];
    };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    foot
    kitty
    direnv
    waybar
    git
    tree
    hyprpaper
    wofi
    swayosd
    firefox
    neovim
    nil
    unzip
    wl-clipboard
    grim
    slurp
    satty
    ripgrep
    fd
    fzf
    yazi
    nixd
    brightnessctl
    tree-sitter
    nodejs
    kdePackages.okular
    wireguard-tools
    pipewire
    qutebrowser
    tmux
    vis
    python315
    xwayland-satellite

    jetbrains.clion
    cmake
    gnumake
    gcc
    gdb
    ninja

  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  security.rtkit.enable = true;

  # =========================================================================
  # OPTIMIZACIÓN DE BATERÍA (TLP para Thinkpad)
  # =========================================================================
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # --- FIX ETHERNET: Evita que TLP corte energía al bus PCIe de la tarjeta de red ---
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "performance";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "on";
    };
  };

  # Configuración de WireGuard
  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = "/etc/wireguard/wg0.conf";
      autostart = false;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
