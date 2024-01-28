{...}: {
  services.rkvm = {
    enable = true;
    server = {
      settings.password = "hellothisisapassword";
      settings.certificate = "/run/secrets/cert";
      settings.key = "/run/secrets/key";
      enable = true;
    };
  };
}
