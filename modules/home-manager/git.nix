# Git configuration for home-manager
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Your Name"; # Change this to your name
    userEmail = "your.email@example.com"; # Change this to your email

    extraConfig = {
      init.defaultBranch = "main";
      push.default = "current";
      pull.rebase = false;

      # Better diff algorithm
      diff.algorithm = "patience";

      # Use separate file for username/password
      credential.helper = "store";

      # Automatically track remote branch
      branch.autosetupmerge = "always";

      # Use short status format
      status.short = true;

      # Show branch info in status
      status.branch = true;
    };

    aliases = {
      # Short aliases for common commands
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";

      # More complex aliases
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      ll = "log --oneline";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";

      # Useful shortcuts
      amend = "commit --amend";
      oops = "commit --amend --no-edit";

      # Clean up
      cleanup = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
    };

    ignores = [
      # OS generated files
      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"
      "Thumbs.db"

      # IDE/Editor files
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"

      # Logs and databases
      "*.log"
      "*.sql"
      "*.sqlite"

      # Runtime data
      "pids"
      "*.pid"
      "*.seed"
      "*.pid.lock"

      # Dependency directories
      "node_modules/"

      # Build outputs
      "dist/"
      "build/"
      "target/"
      "*.o"
      "*.so"
      "*.dylib"
    ];
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      # What protocol to use when performing git operations
      git_protocol = "ssh";
      # What editor gh should run when creating issues, pull requests, etc
      editor = "nvim";
      # When to interactively prompt
      prompt = "enabled";
      # A pager program to send command output to
      pager = "less";
    };
  };
}
