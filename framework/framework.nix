{...}: {
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
    "preempt=voluntary"
    "intel_iommu=on"
    "iommu.passthrough=1"
    "acpi_osi=\"!Windows 2020\""
    "nvme.noacpi=1"
  ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
}
