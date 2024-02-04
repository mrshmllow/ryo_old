{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pinentry.gnome3
    pinentry
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.caffeine
    gnomeExtensions.appindicator
  ];

  programs.gnupg.agent = {
    pinentryFlavor = "gnome3";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  home-manager.users.marsh = {
    pkgs,
    config,
    ...
  }: {
    imports = [./dconf.nix];
  };
}
