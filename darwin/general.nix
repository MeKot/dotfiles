{ pkgs, ... }:

let

  appleFonts = pkgs.callPackage ./fonts/apple-fonts-sf.nix {};
  hackNerdFont = pkgs.callPackage ./fonts/font-hack-nerd-font.nix {};

in

{
  environment.systemPackages = with pkgs; [
    tmux
  ];

  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     recursive
     appleFonts
     hackNerdFont
     sketchybar-app-font
     hack-font
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
  nix.gc.options = "--delete-older-than 15d";

  nix.optimise.automatic = true;
  nix.optimise.interval.Hour = 4;
}
