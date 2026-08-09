{ config, lib, pkgs, ... }:

let
  inherit (config.users.primaryUser) fullName username;
in
{
  # Nix --------------------------------------------------------------------------------------------

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-public-keys = [
    "mekot.cachix.org-1:Yuv6hTpLeV5m8Un4buk+C8z2Went6peRvPzgS7LjmsA="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  nixpkgs.config.allowUnfree = true;

  # Store management -------------------------------------------------------------------------------

  nix.gc.automatic = true;
  nix.gc.dates = "03:00";
  nix.gc.options = "--delete-older-than 14d";

  nix.optimise.automatic = true;
  nix.optimise.dates = "04:00";

  # Locale and keyboard ----------------------------------------------------------------------------

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.xkb = {
    variant = "";
    layout = "gb";
    options = "caps:ctrl_modifier";
  };

  console.useXkbConfig = true;

  # User -------------------------------------------------------------------------------------------

  users.users.${username} = {

    shell = pkgs.zsh;
    useDefaultShell = false;
    isNormalUser = true;
    description = fullName;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = lib.attrValues { inherit (pkgs) zsh gnupg git-crypt; };

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjJcrRin02U8GneOXiX3PvyOTm79OHylNdF/9yW3yxb ivan@kotegov.com"
    ];
  };

  programs.zsh.enable = true;

  programs.command-not-found.enable = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Remote access ----------------------------------------------------------------------------------

  services.tailscale.enable = true;

  services.openssh = {

    enable = true;
    startWhenNeeded = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };

    extraConfig = ''
      KeepAlive yes
      TCPKeepAlive yes
      ClientAliveInterval 30
      ClientAliveCountMax 2
      SetEnv IGNOREOF=10
    '';
  };
}
