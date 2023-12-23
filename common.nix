{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = ''
    plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
  '';

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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

  time.hardwareClockInLocalTime = true;

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
  services.xserver = {
    enable = true;
    layout = "au";
    xkbVariant = "";

    excludePackages = [pkgs.xterm];
    desktopManager.xterm.enable = false;
  };

  services.fwupd.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  environment.shells = with pkgs; [fish];
  programs.fish.enable = true;
  environment.pathsToLink = ["/share/bash-completion"];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      source-han-sans
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];
    fontconfig = {
      defaultFonts = {
        monospace = ["JetBrainsMono"];
      };
    };
  };

  # services.emacs.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
