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
    enableFishIntegration = true;
    settings = {
      version = 2;
      final_space = true;
      console_title_template = "{{ .Shell }} in {{ .Folder }}";
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              type = "path";
              style = "plain";
              background = "transparent";
              foreground = "blue";
              template = "{{ .Path }}";
              properties = {
                style = "full";
              };
            }
            {
              type = "git";
              style = "plain";
              foreground = "p:grey";
              background = "transparent";
              template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
              properties = {
                branch_icon = "";
                commit_icon = "@";
                fetch_status = true;
              };
            }
          ];
        }
        {
          type = "rprompt";
          overflow = "hidden";
          segments = [
            {
              type = "executiontime";
              style = "plain";
              foreground = "yellow";
              background = "transparent";
              template = "{{ .FormattedMs }}";
              properties = {
                threshold = 5000;
              };
            }
          ];
        }
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "text";
              style = "plain";
              foreground_templates = [
                "{{if gt .Code 0}}red{{end}}"
                "{{if eq .Code 0}}magenta{{end}}"
              ];
              background = "transparent";
              template = "❯";
            }
          ];
        }
      ];
      transient_prompt = {
        foreground_templates = [
          "{{if gt .Code 0}}red{{end}}"
          "{{if eq .Code 0}}magenta{{end}}"
        ];
        background = "transparent";
        template = "❯ ";
      };
      secondary_prompt = {
        foreground = "magenta";
        background = "transparent";
        template = "❯❯ ";
      };
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
    nix-direnv.enable = true;
  };

  # Zoxide for smart directory jumping
  programs.zoxide = {
    enable = true;
  };

  # FZF for fuzzy finding
  programs.fzf = {
    enable = true;
  };
}
