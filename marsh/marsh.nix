{
  pkgs,
  home-manager,
  ...
}: {
  nixpkgs.config.allowUnfree = true; 

  imports = [
    home-manager.nixosModule
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marsh = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "marsh";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      ripgrep
      flatpak-builder
      gcc

      # texlive.combined.scheme-full.out
      pandoc
      yt-dlp

      # Code Stuff
      nodejs_20
      nodePackages_latest.pnpm
      bun

      # Neovim stuff
      lua-language-server
      nil
      stylua
      alejandra
      prettierd
      nodePackages_latest.pyright
      nodePackages_latest.vscode-css-languageserver-bin
      nodePackages_latest.typescript-language-server
      nodePackages_latest."@tailwindcss/language-server"
      nodePackages_latest.vscode-json-languageserver-bin
      nodePackages_latest.yaml-language-server
      nodePackages.mermaid-cli
    ];
  };

  home-manager.users.marsh = {
    pkgs,
    config,
    ...
  }: {
    nixpkgs.config.allowUnfree = true;
    imports = [
      ./programs/shell.nix
      ./programs/bat.nix
      ./programs/git.nix
      ./programs/gpg.nix
    ];
    home.stateVersion = "23.11";
    programs.kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      extraConfig = ''
        cursor_blinking_stop_blinking_after 0
        mouse_hide_wait -1
        hide_window_decorations yes
        window_padding_width 10
      '';
      font.name = "JetBrainsMono Nerd Font Mono";
      # linux_display_server x11
    };
    programs.lazygit.enable = true;
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        # black, red, green, blue, yellow, purple, cyan, white
        character = {
          success_symbol = "[>](bold purple)";
          error_symbol = "[>](bold red)";
          vimcmd_symbol = "[<](bold purple)";
          vimcmd_replace_one_symbol = "[<](bold red)";
          vimcmd_replace_symbol = "[<](bold red)";
          vimcmd_visual_symbol = "[<](bold cyan)";
        };
        directory = {
          style = "bold purple";
        };
        aws = {
          disabled = true;
        };
      };
    };
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_KEY = "CE4CECD4861112D38ED3393A767B8880F5AAEB9C";
      };
    };
    programs.eza = {
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
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = null;
      };
    };
    #programs.emacs = {
    #  enable = true;
    #};
    programs.mpv = {
      enable = true;
      config = {
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
      };
    };
  };
}
