{
  config,
  pkgs,
  ...
}: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.marsh.extraGroups = ["libvirtd"];

  services.spice-vdagentd.enable = true;
}
