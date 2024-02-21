{pkgs, ...}: let
  mpv_scripts = pkgs.fetchFromGitHub {
    owner = "Eisa01";
    repo = "mpv-scripts";
    rev = "ed615db8bc1dd7820d5ec9faa45426f64a69ec58";
    hash = "sha256-fg0JJaEnkzFvvipi8p1h2Ik589Mgfrf1dJ2WCCWwu+U=";
  };
in {
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu";
      profile = "gpu-hq";
    };
  };
  home.file.".config/mpv/scripts/SmartCopyPaste_II.lua" = {source = "${mpv_scripts}/scripts/SmartCopyPaste_II.lua";};
  home.file.".config/mpv/script-opts/SmartCopyPaste_II.config" = {
    text = ''
      linux_paste=wl-paste
      linux_copy=wl-copy
    '';
  };
}
