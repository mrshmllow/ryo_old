{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gnupg.agent = {
    pinentryFlavor = "gnome3";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard

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
  };

  services.printing.enable = true;

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
