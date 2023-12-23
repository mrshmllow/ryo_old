{
  pkgs,
  wsl,
  ...
}: {
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

  networking.hostName = "marsh-wsl";

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "23.11";
}
