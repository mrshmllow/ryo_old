{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    gnome3.adwaita-icon-theme
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    kickoff
    mako # notification system developed by swaywm maintainer
    pamixer
    pavucontrol
    playerctl
  ];

  home-manager.users.marsh = {...}: {
    home.file.".config/kickoff/config.toml".source = ./kickoff.config.toml;
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
      pause = "${lib.getExe pkgs.playerctl} pause";
      lock = "${lib.getExe pkgs.swaylock} -fF";
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
