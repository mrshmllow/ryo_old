{pkgs, ...}: {
  programs.bat = {
    enable = true;
    themes = {
      catppuccin_mocha = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "1g2r6j33f4zys853i1c5gnwcdbwb6xv5w6pazfdslxf69904lrg9";
        };
        file = "Catppuccin-mocha.tmTheme";
      };
    };
    config = {
      theme = "catppuccin_mocha";
      style = [
        "changes"
        "header"
        "numbers"
      ];
    };
  };
}
