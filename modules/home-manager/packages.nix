# Package configuration for home-manager
{ config, pkgs, ... }:

{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Development tools
    gcc
    cmake
    gnumake
    pkg-config
    nodejs_20
    python3
    rustc
    cargo
    go

    # CLI utilities
    bat
    eza
    fd
    ripgrep
    fzf
    jq
    yq
    tree
    htop
    btop
    neofetch
    wget
    curl
    rsync

    # Archive tools
    zip
    unzip
    p7zip
    gnutar

    # Text editors and IDEs
    neovim
    emacs

    # Media
    mpv
    imagemagick

    # Networking
    nmap
    speedtest-cli

    # System monitoring
    iotop
    nethogs
    lsof
    strace

    # Version control (additional to git)
    gh # GitHub CLI

    # Document processing
    pandoc
    texlive.combined.scheme-medium
  ];
}
