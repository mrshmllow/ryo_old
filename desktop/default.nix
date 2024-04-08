{
  nix-gaming,
  pkgs,
  ...
}: {
  imports = [
    nix-gaming.nixosModules.pipewireLowLatency
    ./apps
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "au";
    xkb.variant = "";

    excludePackages = [pkgs.xterm];
    desktopManager.xterm.enable = false;
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code-symbols
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];
    fontconfig = {
      defaultFonts = {
        monospace = ["JetBrainsMono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
    };
  };

  services.printing.enable = true;

  programs.gamemode.enable = true;

  services.xserver.displayManager.autoLogin.user = "marsh";

  home-manager.users.marsh = {
    pkgs,
    config,
    ...
  }: {
    imports = [./dconf.nix];
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
    };
  };
}
