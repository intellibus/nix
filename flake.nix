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
      # Supported systems for development shells and packages
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Helper function to generate an attribute set for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Import nixpkgs for each system
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild switch --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME: Replace with your hostname
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            # > Our main nixos configuration file <
            ./hosts/default/configuration.nix

            # > Home-manager module <
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.jager = import ./hosts/default/home.nix;
            }
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager switch --flake .#your-username@your-hostname'
      homeConfigurations = {
        "jager@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/default/home.nix ];
        };
      };

      # Development shell for working on this configuration
      # Available through 'nix develop' or automatically via direnv
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            name = "nixos-config";

            packages = with pkgs; [
              # Nix development tools
              nix-output-monitor
              nix-tree
              nix-diff
              nixpkgs-fmt
              nixpkgs-review
              nix-update

              # Git and development tools
              git
              pre-commit

              # Documentation tools
              mdbook

              # System tools
              curl
              wget
              jq

              # Optional: Add more tools as needed
              htop
              tree
            ];

            shellHook = ''
              echo "🚀 Welcome to your NixOS configuration development environment!"
              echo ""
              echo "Available commands:"
              echo "  ./setup.sh     - Interactive configuration setup"
              echo "  ./test.sh      - Run configuration tests"
              echo "  ./validate.sh  - Validate configuration structure"
              echo "  make check     - Check flake syntax"
              echo "  make format    - Format Nix code"
              echo "  make update    - Update flake inputs"
              echo ""
              echo "Documentation:"
              echo "  README.md              - Main documentation"
              echo "  docs/NVIDIA.md         - NVIDIA setup guide"
              echo ""
            '';
          };
        });

      # Packages for this flake
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          # Default package - could be a script or tool for managing the config
          default = pkgs.writeShellScriptBin "nixos-config-helper" ''
            echo "NixOS Configuration Helper"
            echo "Run ./setup.sh to get started!"
          '';
        });

      # Formatter for 'nix fmt'
      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
    };
}
