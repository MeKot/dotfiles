{
  description = "Full Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixpkgs/nixos-unstable";

    home-manager = {

      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 

  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {

      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {
  
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {

      inherit system;

      specialArgs = {inherit inputs;};
      modules = [

        ./system/configuration.nix

        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
