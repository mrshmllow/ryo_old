{
  pkgs,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    # signing = {
    #   key = "CE4CECD4861112D38ED3393A767B8880F5AAEB9C";
    #   signByDefault = true;
    # };
    userEmail = "marshycity@gmail.com";
    userName = "marshmallow";
    extraConfig = {
      init.defaultBranch = "main";
      http = {
        postBuffer = 157286400;
      };
    };
    lfs.enable = true;
    aliases = {
      "blame" = "blame -w -C -C -C -L";
    };
    extraConfig = {
      rerere = {
        enabled = true;
      };
      column.ui = "auto";
      branch = {
        sort = "-committerdate";
      };
    };
  };
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    settings.version = 1;
  };
}
