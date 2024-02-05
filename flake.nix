{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    wsl.url = "github:nix-community/NixOS-WSL";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-gaming.url = "github:fufexan/nix-gaming";
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    rust = {pkgs, ...}: {
      nixpkgs.overlays = [inputs.fenix.overlays.default inputs.neovim-nightly-overlay.overlay];
      environment.systemPackages = with pkgs; [
        (inputs.fenix.packages.x86_64-linux.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        rust-analyzer-nightly
      ];
    };
  in {
    packages.x86_64-linux.default = inputs.fenix.packages.x86_64-linux.minimal.toolchain;
    nixosConfigurations = {
      "marsh-framework" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./common.nix
          ./hosts/framework
          ./marsh

          ./desktop
          ./desktop/gnome
          rust
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
          rust
        ];
      };
      "pi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/pi
        ];
      };
      "marsh-wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./common.nix
          ./hosts/wsl
          ./marsh
          rust
        ];
      };
    };
  };
}
