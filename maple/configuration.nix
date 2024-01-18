{
  config,
  pkgs,
  nix-gaming,
  home-manager,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-238f587f-cba0-43d1-ac83-89f480c8fa08".device = "/dev/disk/by-uuid/238f587f-cba0-43d1-ac83-89f480c8fa08";
  networking.hostName = "maple";

  users.users.marsh.packages = with pkgs; [
    osu-lazer-bin
    blender-hip
  ];

  services.xserver.videoDrivers = ["amdgpu"];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    amdvlk
  ];

  # For 32 bit applications
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  hardware.opengl.driSupport32Bit = true;

  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["marsh"];

  # Star citizen stuff
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  environment.systemPackages = [
    nix-gaming.packages.${pkgs.system}.star-citizen
  ];

  home-manager.users.marsh = {
    pkgs,
    config,
    ...
  }: {
    systemd.user.services = {
      "drive" = {
        Unit = {
          Description = "google drive";
        };
        Service = {
          Type = "simple";
          ExecStart = ''${pkgs.rclone}/bin/rclone mount --vfs-cache-mode=full drive: /home/marsh/Drive'';
          Wants = "network-online.target";
          After = "network-online.target";
          Enabled = true;
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
