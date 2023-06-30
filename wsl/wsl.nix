{ lib, pkgs, config, modulesPath, wsl, ... }: {
  imports = [
    wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "marsh";
    startMenuLaunchers = true;

    wslConf = {
      automount = {
        root = "/mnt";
      };
    };

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "22.05";
}
