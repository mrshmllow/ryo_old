{pkgs, ...}: let
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
in {
  environment.systemPackages = with pkgs; [
    dbus # make dbus-update-activation-environment available in the path
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    gnome3.adwaita-icon-theme
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    kickoff
    mako # notification system developed by swaywm maintainer
    i3blocks
    pamixer
    pavucontrol
    playerctl
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
    programs.swaylock = {
      enable = true;
      settings = {
        color = "1e1e2e";
        bs-hl-color = "f38ba8";
        inside-color = "313244";
        ring-color = "313244";
        inside-clear-color = "b4befe";
        ring-clear-color = "b4befe";
        inside-ver-color = "89b4fa";
        ring-ver-color = "89b4fa";
        inside-wrong-color = "f38ba8";
        ring-wrong-color = "f38ba8";
        key-hl-color = "cba6f7";
        line-color = "1e1e2e";
        text-caps-lock-color = "fab387";
      };
    };
    services.swayidle = let
      pause = "${pkgs.playerctl}/bin/playerctl pause";
      lock = "${pkgs.swaylock}/bin/swaylock -fF";
    in {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = pause;
        }
        {
          event = "before-sleep";
          command = lock;
        }
      ];
      timeouts = [
        {
          timeout = 60;
          command = "${pause}; ${lock}";
        }
        {
          timeout = 90;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
