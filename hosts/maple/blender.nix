{pkgs, ...}: {
  users.users.marsh.packages = with pkgs; [
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
}