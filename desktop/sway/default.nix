{
  pkgs,
  lib,
  ...
}: let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      # What is this doing?
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
    '';
    # gsettings set $gnome_schema gtk-theme 'Dracula'
  };

  colors = {
    text = "#cdd6f4";
    # all .8 opacity
    surface1 = "#45475acc";
    base = "#1e1e2ecc";
    mauve = "#cba6f7cc";
  };
in {
  imports = [../.wayland-wm];

  environment.systemPackages = with pkgs; [
    dbus # make dbus-update-activation-environment available in the path
    gnome3.adwaita-icon-theme
    i3blocks
  ];

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  home-manager.users.marsh = {...}: {
    wayland.windowManager.sway = {
      enable = true;
      package = null;
      config = {
        assigns = {
          "1" = [
            {
              class = "^Google-chrome$";
            }
          ];
          "3" = [
            {
              class = "^vesktop$";
            }
          ];
          "5" = [
            {
              class = "^steam$";
            }
          ];
        };
        floating = {
          criteria = [
            {
              class = "Rofi";
            }
          ];
        };
        gaps = {
          outer = 2;
          inner = 4;
        };
        input = {
          "5426:125:Razer_Razer_DeathAdder_V2_Pro" = {
            accel_profile = "flat";
            pointer_accel = ".5";
          };
          "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
            natural_scroll = "disabled";
          };
        };
        menu = "${lib.getExe pkgs.rofi} -normal-window -show drun";
        modifier = "Mod4";
        output = {
          DP-2 = {
            mode = "1920x1080@144.001Hz";
            bg = "${../wallpaper} fill";
          };
        };
        startup = [
          {command = "${dbus-sway-environment}";}
          {command = "${configure-gtk}";}
        ];
        terminal = "kitty";
        window = {
          titlebar = false;
        };
        keybindings = lib.mkOptionDefault {
          "Mod4+Shift+s" = ''exec IMG=~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).png && ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" $IMG && wl-copy < $IMG'';
          "Mod4+n" = ''exec neovide'';
        };
        bars = [
          {
            position = "top";
            # height = 30;
            colors = {
              statusline = "#ffffff";
              background = colors.base;
              inactiveWorkspace = {
                background = colors.base;
                border = colors.base;
                text = colors.text;
              };
              focusedWorkspace = {
                background = colors.mauve;
                border = colors.mauve;
                text = colors.base;
              };
            };
            statusCommand = lib.getExe' pkgs.i3blocks "i3blocks";
            extraConfig = ''
              gaps 5
            '';
          }
        ];
      };
      extraConfig = ''
        blur enable
        corner_radius 10
        default_dim_inactive 0.1

        layer_effects "panel" blur enable; shadows enable; corner_radius 6
      '';
    };
  };
}
