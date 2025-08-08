{
  description = "Personal NixOS configuration flake";

  inputs = {
    # NixOS official package source, using the unstable channel for latest packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager, used for managing user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware quirks for specific devices
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      # Supported systems for dev shells/formatters
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      # NixOS configuration entrypoints for GitHub Actions runners
      nixosConfigurations = {
        nixos-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/default/configuration.nix
            ./modules/nixos/system.nix
            ./modules/nixos/main-user.nix
            ./modules/nixos/desktop.nix
            ./modules/nixos/optional-services.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."absurdprofit" = import ./hosts/default/home.nix;
              # Pass ciMode to HM so heavy packages are skipped in CI
              home-manager.extraSpecialArgs = { inherit inputs; ciMode = true; };
            }
          ];
        };

        nixos-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/default/configuration.nix
            ./modules/nixos/system.nix
            ./modules/nixos/main-user.nix
            ./modules/nixos/desktop.nix
            ./modules/nixos/optional-services.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."absurdprofit" = import ./hosts/default/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; ciMode = true; };
            }
          ];
        };

        # Back-compat alias for workflows (x86_64)
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/default/configuration.nix
            ./modules/nixos/system.nix
            ./modules/nixos/main-user.nix
            ./modules/nixos/desktop.nix
            ./modules/nixos/optional-services.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."absurdprofit" = import ./hosts/default/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; ciMode = true; };
            }
          ];
        };
      };

      homeConfigurations = {
        "absurdprofit@nixos-x86_64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/default/home.nix ];
        };
        "absurdprofit@nixos-aarch64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/default/home.nix ];
        };
        "absurdprofit@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/default/home.nix ];
        };
      };

      devShells = forAllSystems (_: { });
      packages = forAllSystems (_: { });
      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
    };
}
