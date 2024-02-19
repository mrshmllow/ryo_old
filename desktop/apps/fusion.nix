{
  pkgs,
  lib,
  ...
}: let
  installer = pkgs.fetchurl {
    url = "https://dl.appstreaming.autodesk.com/production/installers/Fusion%20Client%20Downloader.exe";
    name = "Fusion Client Downloader.exe";
    hash = "sha256-IhUPcXgC0I/s2l0wfwyaokG5Hbm60hmvrbeo5PkbWI4=";
  };

  webview = pkgs.fetchurl {
    url = "https://dl.appstreaming.autodesk.com/production/installers/Fusion%20Client%20Downloader.exe";
    name = "MicrosoftEdgeWebView2RuntimeInstallerX64.exe";
    sha256 = "0nzxp64qfn9yii1n7cywl8ym88kzli2ak7sdcva045127s34kk7j";
  };

  xml = pkgs.writeText "NMachineSpecificOptions.xml" ''
    <?xml version="1.0" encoding="UTF-16" standalone="no" ?>
    <OptionGroups>
      <BootstrapOptionsGroup SchemaVersion="2" ToolTip="Special preferences that require the application to be restarted after a change." UserName="Bootstrap">
        <driverOptionId ToolTip="The driver used to display the graphics" UserName="Graphics driver" Value="VirtualDeviceDx9"/></BootstrapOptionsGroup>
    </OptionGroups>
  '';

  WINEPREFIX = "$HOME/Fusion360";

  pname = "fusion";

  tricksFmt = builtins.concatStringsSep " " ["arial" "vcrun2019" "win10"];

  script = pkgs.writeShellScriptBin pname ''
    export WINEARCH="win64"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="${WINEPREFIX}"
    export WINEDLLOVERRIDES="api-ms-win-crt-private-l1-1-0,api-ms-win-crt-conio-l1-1-0,api-ms-win-crt-convert-l1-1-0,api-ms-win-crt-environment-l1-1-0,api-ms-win-crt-filesystem-l1-1-0,api-ms-win-crt-heap-l1-1-0,api-ms-win-crt-locale-l1-1-0,api-ms-win-crt-math-l1-1-0,api-ms-win-crt-multibyte-l1-1-0,api-ms-win-crt-process-l1-1-0,api-ms-win-crt-runtime-l1-1-0,api-ms-win-crt-stdio-l1-1-0,api-ms-win-crt-string-l1-1-0,api-ms-win-crt-utility-l1-1-0,api-ms-win-crt-time-l1-1-0,atl140,concrt140,msvcp140,msvcp140_1,msvcp140_atomic_wait,ucrtbase,vcomp140,vccorlib140,vcruntime140,vcruntime140_1=n,b;adpclientservice.exe="
    export FUSION_IDSDK=false
    PATH=${lib.makeBinPath [pkgs.wineWow64Packages.waylandFull pkgs.winetricks]}:$PATH
    USER="$(whoami)"
    FUSION_LAUNCHER="$WINEPREFIX/drive_c/Users/marsh/Desktop/Autodesk Fusion.lnk"

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q -f ${tricksFmt}
      wineserver -k

      #Remove tracking metrics/calling home
      wine REG ADD "HKCU\Software\Wine\DllOverrides" /v "adpclientservice.exe" /t REG_SZ /d "" /f
      #Navigation bar does not work well with anything other than the wine builtin DX9
      wine REG ADD "HKCU\Software\Wine\DllOverrides" /v "AdCefWebBrowser.exe" /t REG_SZ /d builtin /f
      #Use Visual Studio Redist that is bundled with the application
      wine REG ADD "HKCU\Software\Wine\DllOverrides" /v "msvcp140" /t REG_SZ /d native /f
      wine REG ADD "HKCU\Software\Wine\DllOverrides" /v "mfc140u" /t REG_SZ /d native /f

      wine ${webview} /install

      wine ${installer}

      mkdir -p "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
      cp ${xml} "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"

      # Disable Debug messages on regular runs, we dont have a terminal, so speed up the system by not wasting time prining them into the Void
      # sed -i 's/=env WINEPREFIX=/=env WINEDEBUG=-all env WINEPREFIX=/g' "$HOME/.local/share/applications/wine/Programs/Autodesk/Autodesk Fusion.desktop"

      wineserver -k
    fi

    cd $WINEPREFIX

    ${pkgs.dxvk}/bin/setup_dxvk.sh install --symlink

    xdg-mime default adskidmgr-opener.desktop x-scheme-handler/adskidmgr

    wine "$FUSION_LAUNCHER" "$@"
    wineserver -w
  '';
  fusion = pkgs.symlinkJoin {
    name = pname;
    paths = [
      # desktopItems
      script
    ];

    nativeBuildInputs = [
      pkgs.copyDesktopItems
    ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        desktopName = "adskidmgr-opener.desktop";
        name = "adskidmgr Scheme Handler";
        exec = ''env WINEPREFIX="\\$HOME/Fusion360" wine "C:\users\marsh\AppData\Local\Autodesk\webdeploy\production\57cd45aa09be2d79663784069561ec17eda99ca8\Autodesk Identity Manager\AdskIdentityManager.exe" %u'';
        mimeTypes = ["x-scheme-handler/adskidmgr"];
      })
    ];

    installPhase = ''
      mkdir -p $out/share/applications

      copyDesktopItems
    '';

    meta = {
      description = "Autodesk Fusion 360";
      license = lib.licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  };
in {
  environment.systemPackages = [fusion];
}
