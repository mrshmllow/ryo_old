{ ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      pi = {
        hostname = "10.1.1.2";
        port = 22;
      };
    };
  };
}
