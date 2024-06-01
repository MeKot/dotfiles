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

    system = "x86_64-linux";
    pkgs = import nixpkgs {

      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {
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
