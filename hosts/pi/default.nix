{
  pkgs,
  nix-minecraft,
  ...
}: {
  imports = [
    nix-minecraft.nixosModules.minecraft-servers
    ./hardware-configuration.nix
    ../../nix.nix
  ];
  nixpkgs.overlays = [nix-minecraft.overlay];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "pi";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9FpVP2ZEPbjcibGlSI5cutue6aaiNNSH3syLFzrpbj marsh@marsh-framework"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRXTpL1qfcm78/eofQDdpMmquk/N8LqKh7tdMnXwbwT"
  ];

  nix.settings.auto-optimise-store = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marsh = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    mcrcon
  ];

  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "marsh";
    group = "users	";
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "marsh";
    group = "users";
  };

  services.deluge = {
    enable = true;
    user = "marsh";
    group = "users";
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "marsh";
    group = "users";
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  services.caddy = {
    enable = true;
    virtualHosts."https://req.jerma.fans".extraConfig = ''
      reverse_proxy http://127.0.0.1:5055
    '';
    virtualHosts."http://req.jerma.fans".extraConfig = ''
      reverse_proxy http://127.0.0.1:5055
    '';
    virtualHosts."https://jelly.jerma.fans".extraConfig = ''
      reverse_proxy http://127.0.0.1:8096
    '';
    virtualHosts."http://jelly.jerma.fans".extraConfig = ''
      reverse_proxy http://127.0.0.1:8096
    '';
  };

  services.cfdyndns = {
    enable = true;
    apiTokenFile = "/run/secrets/cf_token";
    records = ["jelly.jerma.fans" "req.jerma.fans"];
  };

  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.openssh.settings.PermitRootLogin = "yes";

  networking.firewall.allowedTCPPorts = [80 448 24454];
  networking.firewall.allowedUDPPorts = [24454];

  system.stateVersion = "23.05";
}
