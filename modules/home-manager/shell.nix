# Shell configuration for home-manager
{ config, pkgs, ... }:

{
  # Fish configuration
  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      cat = "bat";
      ls = "eza";
      tree = "eza --tree";
    };
  };

  # Oh My Posh configuration
  programs.oh-my-posh = {
    enable = true;
    settings = {
      # You can set a preset theme here (for example: "paradox", "jandedobbeleer", etc.)
      # or provide a custom theme JSON path:
      theme = "paradox";
      # theme = "/path/to/your/custom/theme.json";
    };
  };


  # Bash configuration (fallback)
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # Zoxide for smart directory jumping
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # FZF for fuzzy finding
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
