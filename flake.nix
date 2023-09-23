{
  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs.url = "github:nix-community/emacs-overlay";

    wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = {
    self,
    nixpkgs,
    flatpaks,
    neovim-nightly-overlay,
    emacs,
    wsl,
    ...
  } @ attrs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    nodePackages = import ./node-packages/default.nix {
      inherit pkgs;
      inherit system;
      nodejs = pkgs.nodejs_20;
    };
    extendedPkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    } // {
      nodePackages = pkgs.nodePackages // nodePackages;
    };
  in {
    nixosConfigurations.marsh-framework = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs // { 
        inherit extendedPkgs; 
        nixpkgs.config.allowUnfree = true; 
      };
      modules = [
        ({pkgs, ...}: {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        flatpaks.nixosModules.default
        ./common.nix
        ./desktop.nix
        ./framework/framework.nix
        ./marsh/marsh.nix
        ./marsh/desktop.nix
        # ./pi/pi.nix
      ];
    };
    nixosConfigurations.marsh-wsl = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs // { 
        inherit extendedPkgs; 
        nixpkgs.config.allowUnfree = true; 
      };
      modules = [
        ({pkgs, ...}: {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        ./common.nix
        ./wsl/wsl.nix
        ./marsh/marsh.nix
      ];
    };
  };
}
