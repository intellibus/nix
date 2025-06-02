# 🔧 Development Environment Configuration
# Use `nix develop` or `direnv allow` to enter this environment

{
  description = "NixOS Configuration Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "nixos-config-dev";

          buildInputs = with pkgs; [
            # 🔧 Development tools
            git
            gnumake

            # ❄️ Nix tools
            nixpkgs-fmt
            nil # Nix LSP
            nix-tree
            nix-diff

            # 📝 Documentation tools
            mdbook
            pandoc

            # 🤖 CI/CD tools
            pre-commit
            act # Run GitHub Actions locally

            # 🔍 Analysis tools
            statix # Nix linter
            deadnix # Dead code elimination

            # 📦 Utility tools
            jq
            yq
            tree
            ripgrep
            fd
          ];

          shellHook = ''
            echo "🎉 Welcome to the NixOS Configuration Development Environment!"
            echo ""
            echo "📋 Available commands:"
            echo "  make help           - Show available Make targets"
            echo "  ./test.sh           - Run comprehensive tests"
            echo "  ./test.sh --quick   - Run quick tests"
            echo "  pre-commit install  - Set up pre-commit hooks"
            echo "  nixpkgs-fmt .       - Format all Nix files"
            echo "  statix check .      - Lint Nix files"
            echo "  deadnix .           - Find dead code"
            echo ""
            echo "🔍 Analysis tools:"
            echo "  nix flake check     - Validate flake"
            echo "  nix flake show      - Show flake structure"
            echo "  nix-tree            - Explore dependencies"
            echo ""
            echo "📚 Documentation:"
            echo "  Check README.md and docs/ for detailed guides"
            echo ""
            
            # Set up pre-commit if not already done
            if [ ! -f .git/hooks/pre-commit ]; then
              echo "🎣 Setting up pre-commit hooks..."
              pre-commit install
            fi
            
            # Check for updates
            echo "🔄 Current flake status:"
            if [ -f flake.lock ]; then
              echo "  Last update: $(stat -c %y flake.lock 2>/dev/null || stat -f %Sm flake.lock)"
            else
              echo "  No flake.lock found - run 'nix flake update'"
            fi
            echo ""
          '';

          # Environment variables
          NIXOS_CONFIG_DEV = "1";
          EDITOR = "nvim";

          # Add some helpful aliases
          shellAliases = {
            ll = "ls -la";
            nf = "nix flake";
            nfc = "nix flake check";
            nfs = "nix flake show";
            nfu = "nix flake update";
            fmt = "nixpkgs-fmt .";
            test-quick = "./test.sh --quick";
            test-all = "./test.sh";
          };
        };
      });
}
