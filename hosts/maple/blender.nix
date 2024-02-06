{
  pkgs,
  lib,
  ...
}: {
  users.users.marsh.packages = with pkgs; [
    blender-hip

    # Pull required deps for rclone below
    rclone
  ];

  services.xserver.videoDrivers = ["amdgpu"];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
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
          Wants = "network-online.target";
          After = "network-online.target";
        };
        Service = {
          Type = "simple";
          ExecStart = ''${lib.getExe pkgs.rclone} mount --vfs-cache-mode=full drive_personal: /home/marsh/Drive --drive-shared-with-me'';
          Enabled = true;
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
