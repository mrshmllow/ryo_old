{...}: {
  sops = {
    age.keyFile = "/home/marsh/.config/sops/age/keys.txt";
    defaultSopsFile = ./.sops.yaml;
    secrets = {
      rkvm = {
        format = "yaml";
        sopsFile = secrets/rkvm.yaml;
      };
      key = {
        format = "binary";
        sopsFile = secrets/key;
      };
      cert = {
        format = "binary";
        sopsFile = secrets/cert;
      };
    };
  };
}
