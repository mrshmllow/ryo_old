{
  pkgs,
  config,
  ...
}: {
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
}