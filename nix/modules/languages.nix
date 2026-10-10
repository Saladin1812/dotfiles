{ pkgs, ... }:
{
  # Trunk 0.21.14 vendors libdeflate 1.23, whose evex512 attributes fail with GCC 16.
  # Remove this workaround once Trunk updates its bundled libdeflate.
  nixpkgs.overlays = [
    (_final: prev: {
      trunk = prev.trunk.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace "$cargoDepsCopy"/source-registry-*/libdeflate-sys-1.23.1/libdeflate/lib/x86/cpu_features.h \
            --replace-fail 'GCC_PREREQ(14, 0) || CLANG_PREREQ(18, 0, 18000000)' \
              '(GCC_PREREQ(14, 0) && !GCC_PREREQ(16, 0)) || CLANG_PREREQ(18, 0, 18000000)'
        '';
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    bun
    cargo-watch
    cargo-cache
    cmake
    clang
    clang-tools
    dioxus-cli
    dotnetCorePackages.dotnet_10.sdk
    fvm
    go
    gnumake
    jdk
    lua
    zig
    mold
    nodejs
    ngrok
    ninja
    nil
    nixfmt
    mold
    gcc
    python3
    pocketbase
    rustup
    trunk
    uv
    odin
  ];
}
