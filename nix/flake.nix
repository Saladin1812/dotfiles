{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    helium-browser.url = "github:schembriaiden/helium-browser-nix-flake";
    helium-browser.inputs.nixpkgs.follows = "nixpkgs";
    chatgpt-desktop.url = "github:danielbodart/chatgpt-desktop";
    chatgpt-desktop.inputs.nixpkgs.follows = "nixpkgs";
    craft-launcher.url = "github:storytold/craft-launcher/v0.8.1";
    craft-launcher.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    windscribe-nixos = {
      url = "github:Varmisanth/windscribe-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    alacritty-theme.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming-edge = {
      url = "github:powerofthe69/nix-gaming-edge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      alacritty-theme,
      zen-browser,
      nix-cachyos-kernel,
      ...
    }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; zen-browser = inputs.zen-browser; };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.windscribe-nixos.nixosModules.windscribe
          (
            { config, pkgs, ... }:
            {
              # install the overlay
              nixpkgs.overlays = [
                alacritty-theme.overlays.default
                inputs.nix-gaming-edge.overlays.mesa-git
                inputs.nix-gaming-edge.overlays.proton-cachyos
                inputs.nix-gaming-edge.overlays.epic-games-launcher
                (final: prev: {
                  epic-games-launcher = prev.epic-games-launcher.override {
                    source = {
                      version = "0.105.0%2Bgc9a97d0";
                      src = final.fetchurl {
                        url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/0.105.0%2Bgc9a97d0/Linux/EpicGamesLauncher-x86_64.AppImage";
                        hash = "sha256-jk6KcC9MZ28ZDPVyPWKOGTFochIsKs0zjXvDEYdMtt0=";
                      };
                    };
                    buildFHSEnv = args:
                      prev.buildFHSEnv (args // {
                        targetPkgs = fhsPkgs: args.targetPkgs fhsPkgs ++ [ fhsPkgs.libgpg-error ];
                      });
                  };
                })
                nix-cachyos-kernel.overlays.pinned
                (final: prev: {
                  # CachyOS kernels do not yet emit modules.cer. Newer
                  # nixpkgs aggregateModules assumes it exists, so only merge
                  # certificate files that the kernel/module packages provide.
                  aggregateModules = modules:
                    (prev.aggregateModules modules).overrideAttrs (old: {
                      postBuild = builtins.replaceStrings [
                        ''
${"    "}cp --no-preserve=mode,ownership --remove-destination \
${"      "}-- "$(readlink -f modules.cer)" modules.cer
${"    "}sed "1,$(wc -l < modules.order)d; s/\.ko.*/.ko.cer/" modules.dep \
${"        "}| xargs -d'\n' cat >> modules.cer
                        ''
                      ] [
                        ''
                          if test -e "$(readlink -f modules.cer 2>/dev/null)"; then
                            cp --no-preserve=mode,ownership --remove-destination \
                              -- "$(readlink -f modules.cer)" modules.cer
                            sed "1,$(wc -l < modules.order)d; s/\.ko.*/.ko.cer/" modules.dep \
                              | while IFS= read -r cer; do
                                  test -f "$cer" && cat "$cer" >> modules.cer || true
                                done
                          fi
                        ''
                      ] old.postBuild;
                    });
                })
                inputs.nix4vscode.overlays.default
              ];
            }
          )
          inputs.nix-gaming-edge.nixosModules.default
          (
            { config, pkgs, ... }:
            {
              home-manager.users.saladin = hm: {
                programs.alacritty = {
                  enable = true;
                  settings.general.import = [ pkgs.alacritty-theme.tokyo_night ];
                };
              };
            }
          )
        ];
      };
    };
}
