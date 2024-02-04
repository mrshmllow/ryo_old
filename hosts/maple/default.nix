{
  pkgs,
  nix-gaming,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-238f587f-cba0-43d1-ac83-89f480c8fa08".device = "/dev/disk/by-uuid/238f587f-cba0-43d1-ac83-89f480c8fa08";
  networking.hostName = "maple";

  imports = [
    ./hardware-configuration.nix
    ./star-citizen.nix
    ./blender.nix
    ./virt.nix
    ./host-rkvm.nix
  ];

  users.users.marsh.packages = with pkgs; [
    osu-lazer-bin
  ];

  programs.extra-container.enable = true;

  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["marsh"];

  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="ffff", ATTRS{idProduct}=="0035", SYMLINK+="card_reader"
  '';

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "23.11";
}
