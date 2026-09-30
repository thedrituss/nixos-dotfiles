{
  description = "Niri on NixOS";

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

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Inyectar el overlay de Antigravity
            { nixpkgs.overlays = [ antigravity-nix.overlays.default ]; }
            # Módulo de Spicetify para el sistema
            spicetify-nix.nixosModules.default

            ./hosts/thinkpad/configuration.nix
            
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
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