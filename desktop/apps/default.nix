{
  pkgs,
  flatpaks,
  nixpkgs,
  ...
}: {
  imports = [
    flatpaks.nixosModules.default
    ./fusion.nix
    ./emacs
  ];

  users.users.marsh = {
    packages = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };
    in
      with pkgs; [
        jetbrains.idea-ultimate
        jetbrains.rust-rover
        jetbrains.webstorm
        neovide
        obsidian
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
