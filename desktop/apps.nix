{
  pkgs,
  flatpaks,
  ...
}: {
  imports = [
    flatpaks.nixosModules.default
  ];

  users.users.marsh = {
    packages = with pkgs; [
      jetbrains.idea-ultimate
      jetbrains.rust-rover
      neovide
    ];
  };

  home-manager.users.marsh = {
    pkgs,
    config,
    ...
  }: {
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
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    bottles
    pureref
    krita
    clapper
    vieb
    prismlauncher
    mangohud
    gimp
    transmission
    element-desktop
    jellyfin-media-player
    vesktop
  ];

  services.flatpak.enable = true;
  services.flatpak.remotes = {
    "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
    "launchermoe" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
  };
  services.flatpak.packages = [
    "flathub:app/md.obsidian.Obsidian/x86_64/stable"
    "flathub:app/dev.vencord.Vesktop/x86_64/stable"

    "launchermoe:app/moe.launcher.anime-games-launcher/x86_64/stable"
  ];
}