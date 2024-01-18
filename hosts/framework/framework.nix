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
      # https://knowledgebase.frame.work/en_us/optimizing-ubuntu-battery-life-Sye_48Lg3
      INTEL_GPU_MIN_FREQ_ON_AC = 100;
      INTEL_GPU_MIN_FREQ_ON_BAT = 100;

      INTEL_GPU_MAX_FREQ_ON_AC = 1500;
      INTEL_GPU_MAX_FREQ_ON_BAT = 800;

      INTEL_GPU_BOOST_FREQ_ON_AC = 1500;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1000;

      WIFI_PWR_ON_AC = false;
      WIFI_PWR_ON_BAT = false;

      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      RUNTIME_PM_ON_AC = false;
      RUNTIME_PM_ON_BAT = true;

      GPU_SCALING_GOVERNOR_ON_AC = "performance";
      GPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 30;

      CPU_BOOST_ON_AC = true;
      CPU_BOOST_ON_BAT = true;

      CPU_HWP_DYN_BOOST_ON_AC = true;
      CPU_HWP_DYN_BOOST_ON_BAT = false;

      SCHED_POWERSAVE_ON_AC = false;
      SCHED_POWERSAVE_ON_BAT = true;

      NMI_WATCHDOG = false;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      USB_AUTOSUSPEND = true;
      USB_EXCLUDE_AUDIO = true;
      USB_EXCLUDE_BTUSB = true;
      USB_EXCLUDE_PHONE = true;
      USB_EXCLUDE_PRINTER = true;
      USB_EXCLUDE_WWAN = true;

      USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN = false;
    };
  };

  powerManagement.powertop.enable = true;

  services.system76-scheduler.enable = true;

  programs.auto-cpufreq.enable = true;

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

  system.stateVersion = "23.05";
}
