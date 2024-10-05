{ lib, pkgs, ... }: {

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://mekot.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "mekot.cachix.org-1:Yuv6hTpLeV5m8Un4buk+C8z2Went6peRvPzgS7LjmsA="
    ];

    trusted-users = [ "@admin" ];

    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = false;

    experimental-features = [

      "nix-command"
      "flakes"
    ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin" "aarch64-darwin"
    ];

    keep-derivations = true;
    keep-outputs = true;
  };

  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  programs.zsh.enable = true;

  # IK: READ THE CHANGELOG BEFORE CHANGING.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
