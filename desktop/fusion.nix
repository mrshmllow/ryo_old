{
  pkgs,
  lib,
  ...
}: let
  src = pkgs.fetchurl {
    url = "https://dl.appstreaming.autodesk.com/production/installers/Fusion%20Client%20Downloader.exe";
    name = "Fusion Client Downloader.exe";
    hash = "sha256-IhUPcXgC0I/s2l0wfwyaokG5Hbm60hmvrbeo5PkbWI4=";
  };

  pname = "fusion";

  tricksFmt = builtins.concatStringsSep " " ["arial" "vcrun2019" "win10"];

  script = pkgs.writeShellScriptBin pname ''
    export WINEARCH="win64"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="$HOME/Fusion360"
    export WINEDLLOVERRIDES="api-ms-win-crt-private-l1-1-0,api-ms-win-crt-conio-l1-1-0,api-ms-win-crt-convert-l1-1-0,api-ms-win-crt-environment-l1-1-0,api-ms-win-crt-filesystem-l1-1-0,api-ms-win-crt-heap-l1-1-0,api-ms-win-crt-locale-l1-1-0,api-ms-win-crt-math-l1-1-0,api-ms-win-crt-multibyte-l1-1-0,api-ms-win-crt-process-l1-1-0,api-ms-win-crt-runtime-l1-1-0,api-ms-win-crt-stdio-l1-1-0,api-ms-win-crt-string-l1-1-0,api-ms-win-crt-utility-l1-1-0,api-ms-win-crt-time-l1-1-0,atl140,concrt140,msvcp140,msvcp140_1,msvcp140_atomic_wait,ucrtbase,vcomp140,vccorlib140,vcruntime140,vcruntime140_1=n,b;adpclientservice.exe="
    export FUSION_IDSDK="false"
    PATH=${lib.makeBinPath [pkgs.wineWow64Packages.waylandFull pkgs.winetricks]}:$PATH
    USER="$(whoami)"
    FUSION_LAUNCHER="$WINEPREFIX/drive_c/Users/marsh/Desktop/Autodesk Fusion.lnk"

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q -f ${tricksFmt}
      wineserver -k

      # install launcher
      # Use silent install
      wine ${src}
      # -p deploy -g -f log.txt --quiet

      wineserver -k
    fi

    cd $WINEPREFIX

    ${pkgs.dxvk}/bin/setup_dxvk.sh install --symlink

    wine "$FUSION_LAUNCHER" "$@"
    wineserver -w
  '';
  fusion = pkgs.symlinkJoin {
    name = pname;
    paths = [
      # desktopItems
      script
    ];

    meta = {
      description = "Autodesk Fusion 360";
      license = lib.licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  };
in {
  environment.systemPackages = [fusion];
}
