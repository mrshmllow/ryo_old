{
  pkgs,
  nix-minecraft,
  ...
}: {
  imports = [nix-minecraft.nixosModules.minecraft-servers];
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

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

  # services.nginx = {
  #   enable = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;
  #   recommendedGzipSettings = true;
  #   recommendedOptimisation = true;

  #   virtualHosts = {
  #     "jerma.fans" = {
  #       enableACME = true;
  #       forceSSL = true;
  #       locations."/" = {
  #         proxyPass = "http://127.0.0.1:8096";
  #         proxyWebsockets = true;
  #         extraConfig = "proxy_ssl_server_name on;" +
  #           "proxy_pass_header Authorization;";
  #       };
  #     };
  #     "request.jerma.fans" = {
  #       enableACME = true;
  #       forceSSL = true;
  #       locations."/" = {
  #         proxyPass = "http://127.0.0.1:5055";
  #         proxyWebsockets = true;
  #         extraConfig = "proxy_ssl_server_name on;" +
  #           "proxy_pass_header Authorization;";
  #       };
  #     };
  #   };
  # };

  # security.acme.acceptTerms = true;
  # security.acme.defaults.email = "marshycity@gmail.com";

  # security.acme.certs."jerma.fans".extraDomainNames = [ "request.jerma.fans" ];

  # services.cfdyndns = {
  #   enable = true;
  #   apikeyFile = "/etc/nixos/cf_api_key";
  #   email = "marshycity@gmail.com";
  #   records = [ "jerma.fans" "request.jerma.fans" ];
  # };

  nixpkgs.config.allowUnfree = true;
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.fabric = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_20_2;

      serverProperties = {
        gamemode = "survival";
        enable-rcon = true;
        "rcon.password" = "marsh";
        view-distance = 32;
      };

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          Lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/qdzL5Hkg/lithium-fabric-mc1.20.2-0.12.0.jar";
            sha512 = "0ywgqahmrfgl5yqf9hzck216gikv87f9fn6gsq2pp7gmlxaf2wj107104playxviv2ypr0656agjrjir2si3q5anbdi2c2sxsb5zpw8";
          };
          FerriteCore = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/unerR5MN/ferritecore-6.0.1-fabric.jar";
            sha512 = "1bw8svzp1vp30afdmzj2gv8zx4vsj7xcm17ybcxvzbx2b2kash4pgc5lcla7bfwvdnskrq5ddjdcz4511lvqywcv0api4x7py3cczcv";
          };
          SimpleVoiceChat = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/5bFG77fl/voicechat-fabric-1.20.2-2.4.27.jar";
            sha512 = "2s5px5rvai6w3ikgiw2vi24qaw56ca9k088ladvfydvxvjhabvzl7r25fsmzxa3482pxf5gkv4hz9nd6pw843vaim8zd2yfgfzsjd2h";
          };
          SimpleVoiceChatEnhancedGroups = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1LE7mid6/versions/RBMzOtut/enhanced-groups-1.20.2-1.4.0.jar";
            sha512 = "3y77j7c4d4ybrlva1xyns3xbkay92xlr2bznjavyfyp0cngzvzjml75h176lpmfnp17szvsa97m3m29nf85xi5q1d5v7k082qnkl2f2";
          };
        });
      };
    };
  };

  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  networking.firewall.allowedTCPPorts = [80 448 24454];
  networking.firewall.allowedUDPPorts = [24454];

  system.stateVersion = "23.05";
}
