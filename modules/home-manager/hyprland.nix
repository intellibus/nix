# Hyprland configuration for home-manager
{ config, pkgs, lib, ... }:

{
  # Option to enable Hyprland home-manager configuration
  options.hyprland-config = {
    enable = lib.mkEnableOption "Enable Hyprland home-manager configuration";
  };

  config = lib.mkIf config.hyprland-config.enable {
    # Enable Hyprland through home-manager
    wayland.windowManager.hyprland = {
      enable = true;
      # Use the package from NixOS module
      package = null;
      
      # Hyprland configuration
      settings = {
        # Modifier key
        "$mod" = "SUPER";
        
        # Monitor configuration (can be overridden per system)
        monitor = [
          ",preferred,auto,auto"
        ];
        
        # Input configuration
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification
        };
        
        # General configuration
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          allow_tearing = false;
        };
        
        # Decoration
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };
        
        # Animations
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        
        # Dwindle layout
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        
        # Master layout
        master = {
          new_status = "master";
        };
        
        # Gestures
        gestures = {
          workspace_swipe = false;
        };
        
        # Misc settings
        misc = {
          force_default_wallpaper = -1;
        };
        
        # Key bindings
        bind = [
          # Application shortcuts
          "$mod, Q, exec, kitty"
          "$mod, C, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, nautilus"
          "$mod, V, togglefloating,"
          "$mod, R, exec, wofi --show drun"
          "$mod, P, pseudo," # dwindle
          "$mod, J, togglesplit," # dwindle
          "$mod, F, fullscreen,"
          
          # Move focus with mod + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          
          # Move focus with mod + vim keys
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          
          # Move windows
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
          
          # Move windows with vim keys
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"
          
          # Screenshot utilities
          ", Print, exec, grimblast copy area"
          "$mod, Print, exec, grimblast copy screen"
          "SHIFT, Print, exec, grimblast save area ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
          
          # Audio controls
          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
          ", XF86AudioMute, exec, pamixer -t"
          
          # Brightness controls
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          
          # Media controls
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          
          # Lock screen
          "$mod, L, exec, hyprlock"
        ] ++ (
          # Workspaces - bind $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
        
        # Mouse bindings
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        
        # Window rules
        windowrule = [
          "float, ^(pavucontrol)$"
          "float, ^(nm-applet)$"
          "float, ^(blueman-manager)$"
          "float, ^(gnome-calculator)$"
        ];
        
        # Startup applications
        exec-once = [
          "waybar"
          "mako"
          "swww init"
          "hyprpaper"
          "/usr/libexec/polkit-kde-authentication-agent-1"
          "dbus-update-activation-environment --systemd --all"
        ];
      };
      
      # Enable systemd integration
      systemd.variables = ["--all"];
    };
    
    # Configure additional Wayland applications
    programs.kitty = {
      enable = true;
      settings = {
        font_family = "Fira Code";
        font_size = 12;
        background_opacity = "0.9";
        confirm_os_window_close = 0;
      };
    };
    
    # Waybar configuration
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          spacing = 4;
          
          modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "backlight" "battery" "clock" "tray" ];
          
          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              urgent = "";
              focused = "";
              default = "";
            };
          };
          
          "hyprland/window" = {
            format = "{}";
            max-length = 50;
          };
          
          clock = {
            timezone = "America/New_York";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          
          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          
          memory = {
            format = "{}% ";
          };
          
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" ""];
          };
          
          backlight = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };
          
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = ["" "" "" "" ""];
          };
          
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };
        };
      };
      
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: Fira Code, monospace;
          font-size: 13px;
          min-height: 0;
        }
        
        window#waybar {
          background-color: rgba(43, 48, 59, 0.8);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
        }
        
        button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
        }
        
        #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
        }
        
        #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
        }
        
        #workspaces button.focused {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
        }
        
        #workspaces button.urgent {
          background-color: #eb4d4b;
        }
        
        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #tray {
          padding: 0 10px;
          color: #ffffff;
        }
        
        #window,
        #workspaces {
          margin: 0 4px;
        }
        
        .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
        }
        
        .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
        }
        
        #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
        }
        
        @keyframes blink {
          to {
            background-color: #ffffff;
            color: #000000;
          }
        }
        
        #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
      '';
    };
    
    # Mako notification daemon
    services.mako = {
      enable = true;
      backgroundColor = "#2e3440";
      borderColor = "#88c0d0";
      textColor = "#eceff4";
      borderRadius = 5;
      borderSize = 2;
      defaultTimeout = 5000;
      font = "Fira Code 12";
    };
    
    # Configure cursor theme for Wayland
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
    
    # GTK theme configuration for Hyprland
    gtk = {
      enable = true;
      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      font = {
        name = "Sans";
        size = 11;
      };
      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };
      gtk2.extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
    };
    
    # Hyprpaper wallpaper configuration
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "~/.config/wallpaper.png"
        ];
        wallpaper = [
          ",~/.config/wallpaper.png"
        ];
        splash = false;
        ipc = "on";
      };
    };
    
    # Hypridle idle management
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 900;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1200;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
    
    # Hyprlock screen locker configuration
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };
    
    # XDG settings for Wayland
    xdg.configFile."user-dirs.dirs".text = ''
      XDG_DESKTOP_DIR="$HOME/Desktop"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_TEMPLATES_DIR="$HOME/Templates"
      XDG_PUBLICSHARE_DIR="$HOME/Public"
      XDG_DOCUMENTS_DIR="$HOME/Documents"
      XDG_MUSIC_DIR="$HOME/Music"
      XDG_PICTURES_DIR="$HOME/Pictures"
      XDG_VIDEOS_DIR="$HOME/Videos"
    '';
    
    # Environment variables for Wayland applications
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";  # Hint Electron apps to use Wayland
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
  };
}
