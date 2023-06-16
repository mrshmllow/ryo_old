{
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flatpaks.url = "github:GermanBread/declarative-flatpak/dev";

  outputs = {
    self,
    nixpkgs,
    flatpaks,
    ...
  } @ attrs: {
    nixosConfigurations.marsh-framework = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({pkgs, ...}: {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        flatpaks.nixosModules.default
        ./hardware-configuration.nix
        ./configuration.nix
        ./marsh/marsh.nix
      ];
    };
  };
}
