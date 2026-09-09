{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Repositorio de Antigravity
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Repositorio de Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      antigravity-nix,
      spicetify-nix,
      ...
    }@inputs:
    {
      nixosConfigurations = {

        casa = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # AÑADIDO: Pasa los inputs a los archivos configuration.nix externos
          specialArgs = { inherit inputs; };
          modules = [
            # Inyectar el overlay de Antigravity
            { nixpkgs.overlays = [ antigravity-nix.overlays.default ]; }
            # AÑADIDO: Módulo de Spicetify para el sistema
            spicetify-nix.nixosModules.default

            ./hosts/casa/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # AÑADIDO: Pasa los inputs a home.nix por si prefieres configurarlo ahí
                extraSpecialArgs = { inherit inputs; };
                users.thedrituss = import ./home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # AÑADIDO: Pasa los inputs a los archivos configuration.nix externos
          specialArgs = { inherit inputs; };
          modules = [
            # Inyectar el overlay de Antigravity
            { nixpkgs.overlays = [ antigravity-nix.overlays.default ]; }
            # AÑADIDO: Módulo de Spicetify para el sistema
            spicetify-nix.nixosModules.default

            ./hosts/thinkpad/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # AÑADIDO: Pasa los inputs a home.nix por si prefieres configurarlo ahí
                extraSpecialArgs = { inherit inputs; };
                users.thedrituss = import ./home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };

      };
    };
}
