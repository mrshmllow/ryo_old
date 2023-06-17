{pkgs, ...}: {
  nix.extraOptions = ''
    plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  boot.kernelParams = [
  ];

  boot.plymouth.enable = true;

  networking.wireless.userControlled.enable = true;
  # networking.wireless.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.desktopManager.xterm.enable = false;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fwupd.enable = true;

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

  environment.shells = with pkgs; [fish];
  programs.fish.enable = true;

  services.xserver.displayManager.autoLogin.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    rustup
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
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.flatpak.enable = true;
  services.flatpak.remotes = {
    "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
  };
  services.flatpak.packages = [
    "flathub:org.gnome.Builder/x86_64/stable"
    "flathub:xyz.armcord.ArmCord/x86_64/stable"
    "flathub:org.gimp.GIMP/x86_64/stable"
  ];

  system.stateVersion = "23.05";
}
