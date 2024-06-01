{
  description = "Total system Config";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:

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
          };
      );
    };

    primaryUserDefaults = {

      username = "admin";
      fullName = "Ivan Kotegov";
      email = "ivan@kotegov.com";
      nixConfigDirectory = "/Users/admin/dotfiles";
    };

  in {

    lib = inputs.nixpkgs.lib.extend (_: _: {

        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        lsnix = import ./lib/lsnix.nix;
    });

    pkgs = _: prev: {
      pkgs = import inputs.nixpkgs {

        inherit (prev.stdenv) system;
        inherit (nixpkgsDefaults) config;
      };
    };

    apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {

      # Add access to x86 packages for ARM-backed systems
      pkgs-x86 = import inputs.nixpkgs.nixpkgs {

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
      }

    tweaks = _: _: {

      # Temporary overlays
    };

    darwinModules = {

      bootstrap = import ./darwin/bootstrap.nix;
      defaults = import ./darwin/defaults.nix;
      general = import ./darwin/general.nix;
      homebrew = import ./darwin/homebrew.nix;

      primaryUser = import ./modules/darwin/users.nix;
    };

    homeManagerModules = {

      colors = import ./home/colors.nix;
      config-files = import ./home/config-files.nix;
      zsh = import ./home/zsh.nix;
      git = import ./home/git.nix;
      kitty = import ./home/kitty.nix;
      tmux = import ./home/tmux.nix;

      neovim = import ./home/neovim.nix;

    };

    homeManagerConfigurations = {
      admin = home-manager.lib.homeManagerConfiguration {

        inherit pkgs;

        modules = [

          ./users/admin/home.nix
        ];
      };
    };

    nixosConfigurations = {
      nixos = lib.nixosSystem {

	inherit system;
	modules = [

	  ./system/configuration.nix
	];
      };

    };
  };
}
