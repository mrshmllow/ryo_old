{
  pkgs,
  emacs,
  ...
}: {
  nixpkgs.overlays = [emacs.overlays.default];
  services.emacs.package = pkgs.emacs-unstable;
  services.emacs.enable = true;

  users.users.marsh.packages = [
    (pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      extraEmacsPackages = epkgs: [
        epkgs.use-package
      ];
    })
  ];

  home-manager.users.marsh = {...}: {
    home.file.".emacs.d/init.el".text =
      builtins.readFile ./emacs.el;
  };
}
