{
  pkgs,
  home-manager,
  ...
}: {
  imports = [
    home-manager.nixosModule
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marsh = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "marsh";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      webcord-vencord
      ripgrep
      flatpak-builder

      # Code Stuff
      nodejs_20
      nodePackages_latest.pnpm
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate

      # Extra fish stuff
      any-nix-shell

      # Neovim stuff
      lua-language-server
      rust-analyzer
      nil
      alejandra
      nodePackages_latest.pyright
      nodePackages_latest.vscode-css-languageserver-bin
      nodePackages_latest.typescript-language-server
      nodePackages_latest.prettier_d_slim
      nodePackages."@tailwindcss/language-server"
    ];
  };

  home-manager.users.marsh = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      ./dconf.nix
    ];
    home.stateVersion = "23.11";
    # xdg.enable = true;
    home.shellAliases = {
      cat = "bat";
    };
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
    };
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      signing = {
        key = "CE4CECD4861112D38ED3393A767B8880F5AAEB9C";
        signByDefault = true;
      };
      userEmail = "marshycity@gmail.com";
      userName = "marshmallow";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
      publicKeys = [
        {
          source = builtins.fetchurl {
            url = "https://github.com/mrshmllow.gpg";
            sha256 = "1qrdp3hdi891k4v4mzrapcc1gjh1g99yzxx02lrn4im2jl2mzcln";
          };
          trust = 5;
        }
      ];
    };
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
    programs.kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      extraConfig = ''
        cursor_blinking_stop_blinking_after 0
        mouse_hide_wait -1
      '';
      font.name = "FiraCode Nerd Font Mono";
      # linux_display_server x11
    };
    programs.bat = {
      enable = true;
      themes = {
        catppuccin_mocha = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "1g2r6j33f4zys853i1c5gnwcdbwb6xv5w6pazfdslxf69904lrg9";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
      config = {
        theme = "catppuccin_mocha";
      };
    };
    programs.lazygit.enable = true;
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings
      '';
      shellInit = ''
        any-nix-shell fish --info-right | source
      '';
      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf.src;
        }
      ];
    };
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_KEY = "CE4CECD4861112D38ED3393A767B8880F5AAEB9C";
      };
    };
    programs.mr = {
      enable = true;
      settings = {
        "${config.xdg.dataHome}/password-store" = {
          checkout = "git clone git@github.com:mrshmllow/pass.git";
        };
      };
    };
    programs.gh = {
      enable = true;
      enableGitCredentialHelper = true;
      settings.git_protocol = "ssh";
    };
    programs.exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
    programs.browserpass = {
      enable = true;
    };
    nixpkgs.config.allowUnfree = true;
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      ];
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    };
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    xdg = {
      desktopEntries = {
        webcord = {
          name = "Webcord";
          icon = "webcord";
          exec = "${pkgs.webcord-vencord}/bin/webcord --enable-features=UseOzonePlatform --ozone-platform=wayland";
        };
        google-chrome = {
          name = "Google Chrome";
          icon = "google-chrome";
          exec = "${pkgs.google-chrome}/bin/google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland";
        };
      };
    };
    programs.mpv = {
      enable = true;
      config = {
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
        gpu-context = "wayland";
      };
    };
  };
}
