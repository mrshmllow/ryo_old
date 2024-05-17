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

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  networking.hostName = "marsh-wsl";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "23.11";
}
