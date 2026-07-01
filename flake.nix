{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # AÑADIDO: Repositorio de Antigravity
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # AÑADIDO: antigravity-nix en los argumentos de salida
  outputs =
    {
      nixpkgs,
      home-manager,
      antigravity-nix,
      ...
    }:
    {
      nixosConfigurations = {

        casa = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # AÑADIDO: Inyectar el overlay de Antigravity
            { nixpkgs.overlays = [ antigravity-nix.overlays.default ]; }

            ./hosts/casa/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.thedrituss = import ./home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # AÑADIDO: Inyectar el overlay de Antigravity
            { nixpkgs.overlays = [ antigravity-nix.overlays.default ]; }

            ./hosts/thinkpad/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.thedrituss = import ./home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };

      };
    };
}
