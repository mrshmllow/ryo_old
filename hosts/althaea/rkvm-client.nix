{...}: {
  services.rkvm = {
    client = {
      enable = true;
      settings.server = "10.1.1.120:5258";

      settings.certificate = "/run/secrets/cert";
      settings.password = "hellothisisapassword";
    };
  };
}
