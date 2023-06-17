{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";
  };

  outputs = {
    self,
    nixpkgs,
    flatpaks,
    ...
  } @ attrs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
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
