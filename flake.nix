{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";
    wsl.url = "github:nix-community/NixOS-WSL";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-gaming.url = "github:fufexan/nix-gaming";
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    emacs.url = "github:nix-community/emacs-overlay";
    candy.url = "github:mrshmllow/nvim-candy";
  };

  outputs = inputs @ {nixpkgs, ...}: {
    nixosConfigurations = {
      "althaea" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./common.nix
          ./hosts/althaea
          ./marsh

          ./desktop
          ./desktop/sway
        ];
      };
      "maple" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/maple
          ./common.nix
          ./marsh

          ./desktop
          ./desktop/sway
        ];
      };
      "pi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/pi
          ./sops.nix
        ];
      };
      "marsh-wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./common.nix
          ./hosts/wsl
          ./marsh
        ];
      };
    };
  };
}
