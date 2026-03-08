{ lib, pkgs, config, ... }:

let
  inherit (config.mekot) colors;

  # Strip leading '#' — ghostty palette and chrome settings use bare hex
  h = c: builtins.substring 1 6 c;
in

{
  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null; # Installed via Homebrew

    enableZshIntegration = true;

    settings = {
      font-family = "IosevkaMeKot Nerd Font";
      font-size = 15;

      background    = h colors.bg;
      foreground    = h colors.fg;
      cursor-color  = h colors.cursorBg;
      cursor-text   = h colors.cursorFg;

      palette = [
        "0=${h colors.darkest}"
        "1=${h colors.red}"
        "2=${h colors.green}"
        "3=${h colors.yellow}"
        "4=${h colors.blue}"
        "5=${h colors.violet}"
        "6=${h colors.orange}"
        "7=${h colors.fg}"
        "8=${h colors.muted}"
        "9=${h colors.brRed}"
        "10=${h colors.brGreen}"
        "11=${h colors.brYellow}"
        "12=${h colors.brBlue}"
        "13=${h colors.brViolet}"
        "14=${h colors.brOrange}"
        "15=${h colors.fg}"
      ];

      macos-titlebar-style = "hidden";
      window-padding-x = 1;
    };
  };
}
