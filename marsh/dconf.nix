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

    "org/gnome/shell/weather" = {
      locations = "[<(uint32 2, <('Sydney', 'YSSY', true, [(-0.59253928105207498, 2.6386469349889961)], [(-0.59137572239964786, 2.6392287230418559)])>)>]";
    };

    # "org/gnome/desktop/background" = {
    #   color-shading-type = "solid";
    #   picture-options = "zoom";
    #   picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.webp";
    #   picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.webp";
    #   primary-color = "#3071AE";
    #   secondary-color = "#000000";
    # };

    # "org/gnome/desktop/screensaver" = {
    #   color-shading-type = "solid";
    #   picture-options = "zoom";
    #   picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.webp";
    #   primary-color = "#3071AE";
    #   secondary-color = "#000000";
    # };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/shell" = {
      enabled-extensions = ["appindicatorsupport@rgcjonas.gmail.com" "quick-settings-tweaks@qwreey" "blur-my-shell@aunetx" "rounded-window-corners@yilozt"];
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
  };
}
