{
  config,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    settings = {keyserver = "hkps://keys.openpgp.org";};
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
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
