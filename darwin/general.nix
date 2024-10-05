{ pkgs, ... }:
let

  hackNerdFont = pkgs.callPackage ./fonts/font-hack-nerd-font.nix {};

in
{
  programs.nix-index.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
     recursive
     hack-font
     hackNerdFont
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
   ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Store management
  nix.gc.automatic = true;
  nix.gc.interval.Hour = 3;
  nix.gc.options = "--delete-older-than 14d";

  nix.optimise.automatic = true;
  nix.optimise.interval.Hour = 4;
}
