# NixOS Configuration Makefile
# Common commands for managing your NixOS configuration

# Default hostname (change this to match your hostname)
HOSTNAME ?= nixos

# Default target
.DEFAULT_GOAL := help

.PHONY: help switch test test-rebuild test-quick update clean check show format install-to-system dev-shell build-vm list-generations rollback home-switch home-generations lint pre-commit-install pre-commit-run ci-local setup-dev

help: ## Show this help message
	@echo "NixOS Configuration Management"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

switch: ## Rebuild and switch to new configuration
	sudo nixos-rebuild switch --flake .#$(HOSTNAME)

test: ## Run comprehensive tests (shell tests + NixOS rebuild test)
	./test.sh
	sudo nixos-rebuild test --flake .#$(HOSTNAME)

test-rebuild: ## Test NixOS configuration without switching
	sudo nixos-rebuild test --flake .#$(HOSTNAME)

update: ## Update flake inputs
	nix flake update

clean: ## Clean up old generations and garbage collect
	sudo nix-collect-garbage -d
	nix-collect-garbage -d

check: ## Check flake for errors
	nix flake check

show: ## Show flake outputs
	nix flake show

format: ## Format Nix files
	find . -name "*.nix" -exec nixpkgs-fmt {} \;

install-to-system: ## Copy configuration to /etc/nixos (requires setup.sh to be run first)
	@if [ ! -f /etc/NIXOS ]; then \
		echo "Error: This must be run on NixOS"; \
		exit 1; \
	fi
	sudo cp -r ./* /etc/nixos/
	@echo "Configuration copied to /etc/nixos"
	@echo "Run 'cd /etc/nixos && make switch' to apply"

# Development targets
dev-shell: ## Enter development shell with tools
	nix develop

build-vm: ## Build a VM for testing (if VM configuration exists)
	nixos-rebuild build-vm --flake .#$(HOSTNAME)

# Information targets
list-generations: ## List system generations
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback: ## Rollback to previous generation
	sudo nixos-rebuild switch --rollback

# Home manager targets (if using standalone)
home-switch: ## Switch home-manager configuration
	home-manager switch --flake .#$(USER)@$(HOSTNAME)

home-generations: ## List home-manager generations
	home-manager generations

# Development and CI/CD targets
test-quick: ## Run quick tests only
	./test.sh --quick

lint: ## Run Nix linting
	statix check .
	deadnix .

pre-commit-install: ## Install pre-commit hooks
	pre-commit install

pre-commit-run: ## Run pre-commit on all files
	pre-commit run --all-files

ci-local: ## Run CI checks locally
	act -j check-flake --container-architecture linux/amd64
	act -j build-configurations --container-architecture linux/amd64

setup-dev: ## Set up development environment
	pre-commit install
	direnv allow
