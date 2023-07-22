{
  pkgs,
  config,
  ...
}: {
  home.shellAliases = {
    cat = "bat";
    tree = "exa --tree";
    gen_pdf = "pandoc --pdf-engine=xelatex -V geometry:margin=1in -V 'mainfont:DejaVu Serif' -V 'sansfont:DejaVu Sans' -V 'monofont:FiraCode Nerd Font'";
    icat = "kitty +kitten icat";
    note = "vim -c ':lua require(\"orgmode.capture\"):new():open_template_by_shortcut(\"n\")' -c ':lua vim.api.nvim_win_close(1000, false)'";
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      function fish_greeting
        ${pkgs.krabby}/bin/krabby name marshadow --no-title
      end

      fish_vi_key_bindings
    '';
    shellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      set fish_cursor_insert line

      set -x MANPAGER "${pkgs.neovim}/bin/nvim -c 'Man!' -o -"
    '';
    functions = {
      pls = {
        body = ''
          if set -q argv[1]
            set cmd $argv[1]

            switch $cmd
              case 'test'
                  nixos-rebuild --use-remote-sudo test
              case 'build'
                  sudo nixos-rebuild --use-remote-sudo switch
              case 'clean'
                  sudo nix-collect-garbage -d
                  nix store optimise
              case '*'
                  nix-shell -p $cmd
            end
          else
            echo "Error: No command or package provided"
            return 1
          end
        '';
      };
      catch_em_all = {
        body = ''
          while true
            ${pkgs.krabby}/bin/krabby random
            sleep 1
          end
        '';
      };
    };
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
  programs.bash = {
    enable = true;
    historyFile = "${config.xdg.dataHome}/bash/history";
    enableCompletion = true;
  };
}
