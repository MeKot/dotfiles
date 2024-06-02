{
  description = "System Config";

  inputs = {

    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    mac-app-util.url = "github:hraban/mac-app-util";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, home-manager, flake-utils, mac-app-util, ... }@inputs:

  let

    inherit (self.lib) attrValues makeOverridable mkForce optionalAttrs singleton;

    homeStateVersion = "24.05";

    nixpkgsDefaults = {

      config = {
        allowUnfree = true;
      };

      overlays = attrValues self.overlays ++ singleton (

          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {

            inherit (final.pkgs-x86)
              # This is where the default overlays for x86 packages would come for a mac
              ;
          }) // {

            # add other overlays here (say for another plaform / shared across all archs) here
          }
      );
    };

    primaryUserDefaults = {

      username = "admin";
      fullName = "Ivan Kotegov";
      email = "ivan@kotegov.com";
      nixConfigDirectory = "/Users/admin/dotfiles";
    };

  in {

    lib = inputs.nixpkgs-unstable.lib.extend (_: _: {

        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        lsnix = import ./lib/lsnix.nix;
    });

    overlays = {

      pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };

        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };

        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };

      apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {

        # Add access to x86 packages for ARM-backed systems
        pkgs-x86 = import inputs.nixpkgs-unstable {

          system = "x86_64-dawrin";
          inherit (nixpkgsDefaults) config;
        };
      };

      vimUtils = import ./overlays/vimUtils.nix;
      vimPlugins = final: prev:
        let

        inherit (self.overlays.vimUtils final prev) vimUtils;
      in {
        vimPlugins = prev.vimPlugins.extend (_: _:
            vimUtils.buildVimPluginsFromFlakeInputs inputs [

              # flake input names here for a vim plugin repo
            ]
            );
      };

      tweaks = _: _: {

        # Temporary overlays
      };
    };

    darwinModules = {

      app-utils = mac-app-util.darwinModules.default;

      bootstrap = import ./darwin/bootstrap.nix;
      defaults = import ./darwin/defaults.nix;
      general = import ./darwin/general.nix;
      homebrew = import ./darwin/homebrew.nix;

      primaryUser = import ./modules/darwin/users.nix;
    };

    homeManagerModules = {

      sonokai-colors = import ./home/sonokai-colors.nix;
      config-files = import ./home/config-files.nix;
      zsh = import ./home/zsh.nix;
      git = import ./home/git.nix;
      kitty = import ./home/kitty.nix;
      tmux = import ./home/tmux.nix;

      neovim = import ./home/neovim.nix;
      packages = import ./home/packages.nix;

      colors = import ./modules/home/colors;
      programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;

      home-user-info = { lib, ... }: {
        options.home.user-info =
          (self.darwinModules.primaryUser { inherit lib; }).options.users.primaryUser;
      };
    };

    darwinConfigurations = {
      # Minimal config to bootstrap the system on Mac OS

      bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {

        system = "x86_64-darwin";
        modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsDefaults; } ];
      };

      bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
        system = "aarch64-darwin";
      };

      # Boombox config
      boombox = makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults // {

          modules = attrValues self.darwinModules ++ singleton {

            nixpkgs = nixpkgsDefaults;
            networking.computerName = "boombox";
            networking.hostName = "boombox";
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];

            nix.registry.my.flake = inputs.self;
          };

          extraModules = singleton {

            nix.linux-builder.enable = true;
            nix.linux-builder.maxJobs = 8;
            nix.linux-builder.config = {

              virtualisation.cores = 8;
              virtualisation.darwin-builder.memorySize = 12 * 1024;
            };
          };

          inherit homeStateVersion;
          homeModules = attrValues self.homeManagerModules;
          extraHomeModules = [ mac-app-util.homeManagerModules.default ];
      });

      # Config with small modifications needed/desired for CI with GitHub workflow
      githubCI = self.darwinConfigurations.boombox.override {

        username = "runner";
        nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
        extraModules = singleton {

          environment.etc.shells.enable = mkForce false;
          environment.etc."nix/nix.conf".enable = mkForce false;
          homebrew.enable = mkForce false;
          };
        };
      };

      # Config I use with non-NixOS Linux systems (e.g., cloud VMs etc.)
      # Build and activate on new system with:
      # `nix build .#homeConfigurations.mekot.activationPackage && ./result/activate`
      homeConfigurations.mekot = makeOverridable home-manager.lib.homeManagerConfiguration {

        pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // { system = "x86_64-linux"; });

        modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {

          home.username = config.home.user-info.username;
          home.homeDirectory = "/home/${config.home.username}";
          home.stateVersion = homeStateVersion;
          home.user-info = primaryUserDefaults // {
            nixConfigDirectory = "${config.home.homeDirectory}/.config/nixpkgs";
          };
        });
      };

      # Config with small modifications needed/desired for CI with GitHub workflow
      homeConfigurations.runner = self.homeConfigurations.mekot.override (old: {
        modules = old.modules ++ singleton {
          home.username = mkForce "runner";
          home.homeDirectory = mkForce "/home/runner";
          home.user-info.nixConfigDirectory = mkForce "/home/runner/work/nixpkgs/nixpkgs";
        };
      });
  } // flake-utils.lib.eachDefaultSystem (system: {

    legacyPackages = import inputs.nixpkgs-unstable ( nixpkgsDefaults // { inherit system; } );

    devShells = let pkgs = self.legacyPackages.${system}; in
    {

      python = pkgs.mkShell {

        name = "python310";
        inputsFrom = attrValues {

          inherit (pkgs.pkgs-master.python310Packages) black isort;
          inherit (pkgs) poetry python310 pyright;
        };
      };
    };
  });
}
