{ pkgs, lib, ... }:

let
  mkGodotBin =
    { version, sha512, url }:
    let
      shortVersion = lib.head (lib.splitString "-" version);

      drv = pkgs.stdenv.mkDerivation {
        pname = "godot-editor";
        inherit version;
        src = pkgs.fetchurl { inherit url sha512; };
        strictDeps = true;
        nativeBuildInputs = [ pkgs.unzip ];
        unpackPhase = "unzip $src -d $out";
        installPhase = ''
          mkdir -p $out/bin
          cp $out/Godot_v${version}* $out/bin/godot
          rm $out/Godot_v${version}*
        '';
      };
    in
    # FHS env so dlopen() finds libraries at standard paths (use_sowrap=true in official builds).
    # Deps sourced from:
    #   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/godot/common.nix
    #   https://github.com/godotengine/godot/blob/master/platform/linuxbsd/detect.py
    #   https://github.com/florianvazelle/godot-overlay/blob/main/default.nix
    pkgs.buildFHSEnv {
      name = "godot-${shortVersion}";
      inherit version;

      targetPkgs = p: [
        drv

        # X11
        p.xorg.libX11
        p.xorg.libXcursor
        p.xorg.libXext
        p.xorg.libXfixes
        p.xorg.libXi
        p.xorg.libXinerama
        p.xorg.libXrandr
        p.xorg.libXrender

        # Wayland
        p.wayland
        p.libdecor
        p.libxkbcommon

        # Graphics
        p.libGL
        p.vulkan-loader

        # Audio
        p.alsa-lib
        p.libpulseaudio

        # System
        p.udev
        p.dbus
        p.fontconfig
        p.speechd
        p.glib
      ];

      runScript = "godot";
    };

  # Hashes from: https://github.com/florianvazelle/godot-overlay/blob/main/sources.json
  # Binaries from: https://github.com/godotengine/godot-builds/releases
  versions = {
    "4.6" = {
      version = "4.6-stable";
      sha512 = "0c1bc5e8dca8f892a9a5fd0628b742f399fbd520e5f0051ecac021c0aa4ea5a8f0d237c8ed6b767b2afda7f7a4b32001118f1b04a82e335a5e35b947a1217940";
      url = "https://github.com/godotengine/godot-builds/releases/download/4.6-stable/Godot_v4.6-stable_linux.x86_64.zip";
    };
  };

  defaultVersion = "4.6";

  godotPackages = lib.mapAttrsToList (_: v: mkGodotBin v) versions;

  godotDefault = pkgs.writeShellScriptBin "godot" ''
    exec ${mkGodotBin versions.${defaultVersion}}/bin/godot-${defaultVersion} "$@"
  '';

  godotIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/godotengine/godot/4.6-stable/icon.svg";
    hash = "sha256-FEOul0hCuBdl1bUOanKeu/Qeui6eUVqwkZ8upci49HU=";
  };

  godotIconPkg = pkgs.runCommand "godot-icon" { } ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ${godotIcon} $out/share/icons/hicolor/scalable/apps/godot.svg
  '';

  desktopItem = pkgs.makeDesktopItem {
    name = "godot";
    desktopName = "Godot Engine ${defaultVersion}";
    exec = "${godotDefault}/bin/godot %f";
    icon = "godot";
    comment = "Free and Open Source 2D and 3D game engine";
    categories = [ "Development" "IDE" ];
    mimeTypes = [ "application/x-godot-project" ];
  };

in
{
  environment.systemPackages = godotPackages ++ [ godotDefault desktopItem godotIconPkg ];
}
