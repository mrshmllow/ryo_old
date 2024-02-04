{...}: {
  services.rkvm = {
    server = {
      enable = true;
      settings.password = "hellothisisapassword";
      settings.certificate = "/run/secrets/cert";
      settings.key = "/run/secrets/key";
    };
  };
}
