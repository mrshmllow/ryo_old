{
  pkgs,
  candy,
  lib,
  ...
}: {
  imports = [
    ./nix.nix
    ./sops.nix
  ];

  networking.wireless.userControlled.enable = true;
  # networking.wireless.enable = true;

  # Enable networking
  # networking.networkmanager.enable = true;

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

  services.fwupd.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  environment.shells = with pkgs; [fish];
  programs.fish.enable = true;
  environment.pathsToLink = ["/share/bash-completion"];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  # };

  environment.systemPackages = [
    candy.packages.${pkgs.system}.default
  ];

  environment.variables.EDITOR = lib.mkOverride 900 "nvim";

  programs.direnv.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
