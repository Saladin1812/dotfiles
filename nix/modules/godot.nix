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
        p.libx11
        p.libxcursor
        p.libxext
        p.libxfixes
        p.libxi
        p.libxinerama
        p.libxrandr
        p.libxrender

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

  # Hashes from: nix-prefetch-url.
  # Binaries from: https://github.com/godotengine/godot-builds/releases
  versions = {
    "4.6.2" = {
      version = "4.6.2-stable";
      sha512 = "b6e4d5a716085e9649905be2afe77f723f97853544fb33392ce3d32594c730a95d9eb4d1042ed51508904c9e1d996bd36b7c7a2bf4f93f5b1885e98d81b792e7";
      url = "https://github.com/godotengine/godot-builds/releases/download/4.6.2-stable/Godot_v4.6.2-stable_linux.x86_64.zip";
    };
  };

  defaultVersion = "4.6.2";

  godotPackages = lib.mapAttrsToList (_: v: mkGodotBin v) versions;

  godotDefault = pkgs.writeShellScriptBin "godot" ''
    exec ${mkGodotBin versions.${defaultVersion}}/bin/godot-${defaultVersion} "$@"
  '';

  godotIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/godotengine/godot/4.6.2-stable/icon.svg";
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
