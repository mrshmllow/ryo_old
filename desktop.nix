{
  pkgs,
  nix-gaming,
  ...
}: {
  imports = [
    nix-gaming.nixosModules.pipewireLowLatency
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gnupg.agent = {
    pinentryFlavor = "gnome3";
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    bottles
    pureref
    krita
    clapper
    vesktop

    # GNOME Extensions & Applications
    pinentry.gnome3
    pinentry
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.caffeine
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
  ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    lowLatency = {
      enable = true;
      # defaults (no need to be set unless modified)
      quantum = 64;
      rate = 48000;
    };
  };

  services.printing.enable = true;

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

    "launchermoe:app/moe.launcher.anime-games-launcher/x86_64/stable"
  ];

  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = [ "gist-share" ];
  #   enableTCPIP = true;
  #   authentication = pkgs.lib.mkOverride 10 ''
  #     #type database  DBuser  auth-method
  #     local all       all     trust
  #     host    gist-share    postgres    ::1/128    trust
  #   '';
  # };
}
