{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  services.fprintd.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # https://wiki.archlinux.org/title/Framework_Laptop_13#12th_gen_Turbo-Boost_on_battery_with_tlp
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      # https://community.frame.work/t/guide-linux-battery-life-tuning/6665
      PCIE_ASPM_ON_BAT = "powersupersave";
    };
  };

  powerManagement.powertop.enable = true;

  hardware.sensor.iio.enable = true;

  services.thermald.enable = true;

  networking.hostName = "marsh-framework";

  networking.networkmanager.wifi.backend = "iwd";

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu.passthrough=1"
    "acpi_osi=\"!Windows 2020\""
    "nvme.noacpi=1"
    "preempt=voluntary"
  ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;

  services.flatpak.enable = true;
  services.flatpak.remotes = {
    "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
  };
  services.flatpak.packages = [
    "flathub:org.gnome.Builder/x86_64/stable"
    "flathub:xyz.armcord.ArmCord/x86_64/stable"
    "flathub:org.gimp.GIMP/x86_64/stable"
    "flathub:org.gnome.Platform/x86_64/44"
    "flathub:org.gnome.Boxes/x86_64/stable"
    "flathub:com.transmissionbt.Transmission/x86_64/stable"
    "flathub:org.blender.Blender/x86_64/stable"
    "flathub:im.riot.Riot/x86_64/stable"
    "flathub:rest.insomnia.Insomnia/x86_64/stable"
    "flathub:md.obsidian.Obsidian/x86_64/stable"
    "flathub:com.usebottles.bottles/x86_64/stable"
  ];

  system.stateVersion = "23.05";
}
