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
    extraGroups = ["networkmanager" "wheel" "docker" "openrazer"];
    packages = with pkgs; [
      ripgrep
      flatpak-builder
      gcc

      comma

      # fzf.fish requirements
      fzf
      fd

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
      taplo
      jdt-language-server
      nodePackages_latest.pyright
      nodePackages_latest.vscode-css-languageserver-bin
      nodePackages_latest.typescript-language-server
      nodePackages_latest."@tailwindcss/language-server"
      nodePackages_latest.vscode-json-languageserver-bin
      nodePackages_latest.yaml-language-server
      nodePackages_latest."@astrojs/language-server"
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
      ./programs/ssh.nix
      ./programs/mpv.nix
    ];
    home.stateVersion = "23.11";
    home.file.".face" = {
      source = builtins.fetchurl {
        url = "https://avatars.githubusercontent.com/u/40532058";
        sha256 = "1bfy2npk0q7lsjb0r1i7idl7fhv9lccw91qpa4230yxfmml2vhkp";
      };
    };
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
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require "wezterm"

        function scheme_for_appearance(appearance)
          if appearance:find "Dark" then
            return "Catppuccin Mocha"
          else
            return "Catppuccin Latte"
          end
        end

        return {
          font = wezterm.font 'JetBrainsMono Nerd Font Mono',
          hide_tab_bar_if_only_one_tab = true,
          color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
          window_background_opacity = .9,
          automatically_reload_config = true,
        }
      '';
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
      enableFishIntegration = true;
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
    home.file.".config/neovide/config.toml".text = ''
      vsync = false
      maximized = true
      frame = "none"
    '';
  };
}
