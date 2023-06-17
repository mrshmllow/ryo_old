{
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flatpaks.url = "github:GermanBread/declarative-flatpak/dev";

  outputs = {
    self,
    nixpkgs,
    flatpaks,
    ...
  } @ attrs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      system = system;
    };
    nodePackages = import ./node-packages/default.nix {
      inherit pkgs;
      system = "x86_64-linux";
      nodejs = pkgs.nodejs_20;
    };
    extendedPkgs =
      pkgs
      // {
        nodePackages = pkgs.nodePackages // nodePackages;
      };
  in {
    nixosConfigurations.marsh-framework = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs =
        attrs
        // {
          inherit extendedPkgs;
        };
      modules = [
        ({pkgs, ...}: {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        flatpaks.nixosModules.default
        ./common.nix
        ./framework/framework.nix
        ./marsh/marsh.nix
      ];
    };
  };
}
