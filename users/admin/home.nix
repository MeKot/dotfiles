{ config, pkgs, ... }:

{
  home.username = "admin";
  home.homeDirectory = "/home/admin";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    fzf
    git
    git-crypt
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    gpg.enable = true;

  };

  imports = [
  
    ./zsh.nix
  ];
}
