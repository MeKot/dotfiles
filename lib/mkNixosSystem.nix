inputs:

{ username
, fullName
, email
, nixConfigDirectory # directory on the system where this flake is located
, system ? "x86_64-linux"

# `nix` modules to include
, modules ? [ ]
# Additional `nix` modules to include, useful when reusing a configuration with
# `lib.makeOverridable`.
, extraModules ? [ ]

# Value for `home-manager`'s `home.stateVersion` option.
, homeStateVersion
# `home-manager` modules to include
, homeModules ? [ ]
# Additional `home-manager` modules to include, useful when reusing a configuration with
# `lib.makeOverridable`.
, extraHomeModules ? [ ]
}:

inputs.nixpkgs-unstable.lib.nixosSystem {

  inherit system;
  modules = modules ++ extraModules ++ [
    inputs.home-manager.nixosModules.home-manager
    ({ config, ... }: {

      nix.nixPath.nixpkgs = "${inputs.nixpkgs-unstable}";

      # `home-manager` config
      users.users.${username}.home = "/home/${username}";

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.${username} = {

        inherit username fullName email nixConfigDirectory;

        imports = homeModules ++ extraHomeModules;
        home.stateVersion = homeStateVersion;
        home.user-info = config.users.primaryUser;
      };
    })
  ];
}
