{ pkgs, config, ... }:

let
  inherit (config.mekot) colors;

  # Alacritty uses "0xhex" format (no '#')
  a = c: "0x${builtins.substring 1 6 c}";
in

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "IosevkaMeKot Nerd Font";
        size = 15;
      };

      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };

      colors = {
        primary = {
          background = a colors.bg;
          foreground = a colors.fg;
        };

        cursor = {
          text   = a colors.cursorFg;
          cursor = a colors.cursorBg;
        };

        # Solarized-style slot assignment: violet in magenta slot, orange in cyan slot
        normal = {
          black   = a colors.darkest;
          red     = a colors.red;
          green   = a colors.green;
          yellow  = a colors.yellow;
          blue    = a colors.blue;
          magenta = a colors.violet;
          cyan    = a colors.orange;
          white   = a colors.fg;
        };

        bright = {
          black   = a colors.muted;
          red     = a colors.brRed;
          green   = a colors.brGreen;
          yellow  = a colors.brYellow;
          blue    = a colors.brBlue;
          magenta = a colors.brViolet;
          cyan    = a colors.brOrange;
          white   = a colors.fg;
        };
      };

      window = {
        decorations = "buttonless";
        padding.x = 1;
      };
    };
  };
}
