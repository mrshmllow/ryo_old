{
  pkgs,
  ...
}: {
  services.xserver.displayManager.autoLogin.user = "marsh";

  users.users.marsh = {
    packages = with pkgs; [
      # jetbrains.idea-ultimate
      webcord-vencord
      neovide
    ];
  };

  home-manager.users.marsh = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      ./dconf.nix
    ];
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
    };
    xdg = {
      desktopEntries = {
        # steam = {
        #   name = "Steam";
        #   icon = "steam";
        #   exec = "STEAM_FORCE_DESKTOPUI_SCALING=2 ${pkgs.steam}/bin/steam %U";
        # };
      };
    };
    programs.mpv = {
      config = {
        gpu-context = "wayland";
      };
      scripts = with pkgs; [
        mpvScripts.webtorrent-mpv-hook
      ];
    };
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
      # commandLineArgs = [
      #   "--enable-features=UseOzonePlatform"
      #   "--ozone-platform=wayland"
      # ];
    };
  };
}
