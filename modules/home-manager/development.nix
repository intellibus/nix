# Development environment configuration for home-manager
{ config, pkgs, ... }:

{
  # VS Code configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Nix support
        bbenoist.nix

        # Language support
        ms-python.python
        ms-vscode.cpptools
        rust-lang.rust-analyzer
        golang.go

        # Git integration
        eamodio.gitlens

        # Utilities
        ms-vscode-remote.remote-ssh
        ms-vscode.live-server
        vscodevim.vim

        # Themes
        dracula-theme.theme-dracula
        pkief.material-icon-theme
      ];

      userSettings = {
        "workbench.colorTheme" = "Dracula";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = "'Fira Code', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "terminal.integrated.fontSize" = 12;
        "editor.minimap.enabled" = false;
        "workbench.startupEditor" = "none";
        "explorer.confirmDelete" = false;
        "git.confirmSync" = false;
        "git.autofetch" = true;
      };
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set smartindent
      set wrap
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      
      " Color scheme
      colorscheme desert
      
      " Key mappings
      nnoremap <C-n> :NERDTreeToggle<CR>
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    '';
  };

  # Tmux for terminal multiplexing
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;

    extraConfig = ''
      # Mouse support
      set -g mouse on
      
      # 256 colors
      set -g default-terminal "screen-256color"
      
      # Status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-interval 60
      set -g status-left-length 30
      set -g status-left '#[fg=green](#S) #(whoami)'
      set -g status-right '#[fg=yellow]#(cut -d " " -f 1-3 /proc/loadavg)#[default] #[fg=white]%H:%M#[default]'
    '';
  };

  # Development tools
  home.packages = with pkgs; [
    # Docker and container tools
    docker-compose

    # Database tools
    sqlite
    postgresql

    # API testing
    postman

    # Cloud tools
    terraform
    kubectl

    # Language servers and formatters
    nil # Nix LSP
    nixpkgs-fmt
    nodePackages.prettier
    black # Python formatter
    rustfmt

    # Build tools
    gnumake
    cmake
    ninja

    # Debugging
    gdb
    lldb
  ];
}
