{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    #emacs.url = "github:nix-community/emacs-overlay";

    wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = inputs @ { self, nixpkgs, flatpaks, ... }: {
    nixosConfigurations = {
      "marsh-framework" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          flatpaks.nixosModules.default
          ./common.nix
          ./desktop.nix
          ./framework/framework.nix
          ./marsh/marsh.nix
          ./marsh/desktop.nix
        ];
      };
      "marsh-wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./common.nix
          ./wsl/wsl.nix
          ./marsh/marsh.nix
        ];
      };
    };
  };
}
