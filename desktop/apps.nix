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
  ];

  services.flatpak.enable = true;
  services.flatpak.remotes = {
    "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
    "launchermoe" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
  };
  services.flatpak.packages = [
    "flathub:app/org.gnome.Builder/x86_64/stable"
    "flathub:app/org.gimp.GIMP/x86_64/stable"
    "flathub:app/org.gnome.Boxes/x86_64/stable"
    "flathub:app/com.transmissionbt.Transmission/x86_64/stable"
    "flathub:app/im.riot.Riot/x86_64/stable"
    "flathub:app/rest.insomnia.Insomnia/x86_64/stable"
    "flathub:app/md.obsidian.Obsidian/x86_64/stable"
    "flathub:app/com.github.iwalton3.jellyfin-media-player/x86_64/stable"
    "flathub:app/com.heroicgameslauncher.hgl/x86_64/stable"
    "flathub:runtime/org.gnome.Platform/x86_64/44"
    "flathub:app/io.github.jeffshee.Hidamari/x86_64/stable"
    "flathub:app/com.spotify.Client/x86_64/stable"
    "flathub:app/dev.vencord.Vesktop/x86_64/stable"

    "launchermoe:app/moe.launcher.anime-games-launcher/x86_64/stable"
  ];
}
