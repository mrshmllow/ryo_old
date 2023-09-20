{
...
}: {
  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  services.deluge = {
    enable = true;
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  services.jellyfin = {
    enable = true;
  };
  
  # default port 5055
  services.jellyseerr = {
    enable = true;
  };
}
