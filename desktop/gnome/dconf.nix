{...}: {
  dconf.settings = {
    "org/gnome/builder/editor" = {
      keybindings = "vim";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/shell" = {
      enabled-extensions = ["appindicatorsupport@rgcjonas.gmail.com" "quick-settings-tweaks@qwreey" "blur-my-shell@aunetx"];
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      clock-format = "12h";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "kitty";
      name = "Open Terminal";
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      datemenu-remove-media-control = false;
      datemenu-remove-notifications = false;
      list-buttons = "[{\"name\":\"SystemItem\",\"title\":null,\"visible\":true},{\"name\":\"OutputStreamSlider\",\"title\":null,\"visible\":true},{\"name\":\"InputStreamSlider\",\"title\":null,\"visible\":false},{\"name\":\"St_BoxLayout\",\"title\":null,\"visible\":true},{\"name\":\"BrightnessItem\",\"title\":null,\"visible\":true},{\"name\":\"NMWiredToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMWirelessToggle\",\"title\":\"Wi-Fi\",\"visible\":true},{\"name\":\"NMModemToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMBluetoothToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMVpnToggle\",\"title\":null,\"visible\":false},{\"name\":\"BluetoothToggle\",\"title\":\"Bluetooth\",\"visible\":true},{\"name\":\"PowerProfilesToggle\",\"title\":\"Power Mode\",\"visible\":false},{\"name\":\"NightLightToggle\",\"title\":\"Night Light\",\"visible\":true},{\"name\":\"DarkModeToggle\",\"title\":\"Dark Style\",\"visible\":true},{\"name\":\"KeyboardBrightnessToggle\",\"title\":\"Keyboard\",\"visible\":false},{\"name\":\"RfkillToggle\",\"title\":\"Airplane Mode\",\"visible\":true},{\"name\":\"RotationToggle\",\"title\":\"Auto Rotate\",\"visible\":false},{\"name\":\"CaffeineToggle\",\"title\":\"Caffeine\",\"visible\":true},{\"name\":\"DndQuickToggle\",\"title\":\"Do Not Disturb\",\"visible\":true},{\"name\":\"BackgroundAppsToggle\",\"title\":\"No Background Apps\",\"visible\":false},{\"name\":\"MediaSection\",\"title\":null,\"visible\":false},{\"name\":\"Notifications\",\"title\":null,\"visible\":false}]";
      media-control-compact-mode = false;
      media-control-enabled = false;
      notifications-enabled = false;
    };
  };
}
