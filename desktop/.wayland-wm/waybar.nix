{...}: {
  home-manager.users.marsh = {config, ...}: {
    programs.waybar = {
      enable = true;
      settings = {
        top = {
          position = "bottom";
          height = 30;
          spacing = 4;
          modules-left = ["sway/workspaces" "sway/mode" "sway/scratchpad"];
          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };
          "sway/scratchpad" = {
            format = "<span color=\"#a6adc8\">STASH</span> {count}";
            show-empty = false;
            tooltip = true;
            tooltip-format = "{app}: {title}";
          };

          modules-center = ["clock"];
          clock = {
            format = "{:%a %b %e %I:%M %p}";
            tooltip-format = "{:%m/%d/%Y %H:%M}";
          };

          modules-right = [
            "cpu"
            "custom/memory"
            "custom/gpu-usage"
            "custom/gpu-memory"
            "pulseaudio"
            "network"
            "tray"
            "battery"
          ];
          cpu = {
            format = "<span color=\"#a6adc8\">CPU</span> {usage}% ";
            tooltip = false;
          };
          "custom/memory" = {
            exec = "free -h --si | grep Mem: | awk '{print $3}'";
            format = "{} ";
            return-type = "";
            interval = 1;
          };
          "custom/gpu-usage" = {
            exec = "cat /sys/class/hwmon/hwmon0/device/gpu_busy_percent";
            format = "<span color=\"#a6adc8\">GPU</span> {}% ";
            return-type = "";
            interval = 1;
          };
          "custom/gpu-memory" = {
            exec = "cat /sys/class/hwmon/hwmon0/device/mem_info_vram_used | numfmt --to=iec";
            format = "{} ";
            return-type = "";
            interval = 1;
          };
          pulseaudio = {
            format = "<span color=\"#a6adc8\">VOL</span> {volume}% {icon}";
            format-muted = "<span color=\"#a6adc8\">MUTED</span>";

            format-bluetooth = "<span color=\"#a6adc8\">BT</span> {volume}%";
            format-bluetooth-muted = "<span color=\"#a6adc8\">BT MUTED</span>";

            on-click = "pavucontrol --tab=3";
          };
          network = {
            format-wifi = "<span color=\"#a6adc8\">WIFI</span> {essid} ";
            format-ethernet = "<span color=\"#a6adc8\">WIRED</span> ";

            tooltip-format = "{ifname} via {gwaddr}";

            format-linked = "<span color=\"#a6adc8\">NO IP</span> {ifname} ";
            format-disconnected = "NO IP ";

            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          battery = {
            format = "<span color=\"#a6adc8\">BAT</span> {capacity}% ";
            format-charging = "<span color=\"#a6adc8\">BAT+</span> {capacity}% ";
            format-plugged = "<span color=\"#a6adc8\">BAT~</span> {capacity}% ";
            tooltip-format = "{time}";
          };
          tray = {
            icon-size = 21;
            spacing = 10;
          };
        };
      };
      style = ''
        * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
            font-size: 14px;
        }

        window#waybar {
            background-color: transparent;
            color: #cdd6f4;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        button {
            border: none;
            border-radius: 0;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
            background: inherit;
        }

        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #a6adc8;
        }

        #workspaces button.focused {
            color: #cba6f7;
        }

        #workspaces button.urgent {
            color: #f38ba8;
        }

        .modules-left, .modules-right, .modules-center {
          background-color: #1e1e2e;
          margin-left: 8px;
          margin-right: 8px;
          margin-bottom: 4px;

          padding: 0px 6px;

          border-radius: 8px;
        }
      '';
    };
  };
}
