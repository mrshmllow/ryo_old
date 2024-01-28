{
  nix-gaming,
  lib,
  pkgs,
  ...
}: {
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  environment.systemPackages = [
    nix-gaming.packages.${pkgs.system}.star-citizen
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  zramSwap.enable = true;
}
