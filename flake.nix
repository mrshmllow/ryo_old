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

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    fenix = {
      url = "github:nix-community/fenix/monthly";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flatpaks,
    nix-minecraft,
    fenix,
    auto-cpufreq,
    neovim-nightly-overlay,
    ...
  }: {
    packages.x86_64-linux.default = fenix.packages.x86_64-linux.minimal.toolchain;
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
          auto-cpufreq.nixosModules.default
          ({pkgs, ...}: {
            nixpkgs.overlays = [fenix.overlays.default neovim-nightly-overlay.overlay];
            environment.systemPackages = with pkgs; [
              (fenix.packages.x86_64-linux.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              rust-analyzer-nightly
            ];
          })
        ];
      };
      "pi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./pi/configuration.nix
          ./pi/hardware-configuration.nix
        ];
      };
      "marsh-wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./common.nix
          ./wsl/wsl.nix
          ./marsh/marsh.nix
          # TODO: De-dup
          ({pkgs, ...}: {
            nixpkgs.overlays = [fenix.overlays.default neovim-nightly-overlay.overlay];
            environment.systemPackages = with pkgs; [
              (fenix.packages.x86_64-linux.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              rust-analyzer-nightly
            ];
          })
        ];
      };
    };
  };
}
