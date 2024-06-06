{ config, ... }:

# TODO: finish tweaking the colors
{

  colors.sonokai = {

    colors = {
      color0    = "#1f1e1c";
      color1    = "#f86882";
      color2    = "#a6cd77";
      color3    = "#f0c66f";
      color4    = "#81d0c9";
      color5    = "#e68fc7";
      color6    = "#f08d71";
      color7    = "#e4e3e1";
      color8    = "#49403c";
      color9    = "#cd0a2d";
      color10   = "#e9bb84";
      color11   = "#f0e66f";
      color12   = "#8dc8de";
      color13   = "#8fe6da";
      color14   = "#e9552c";
      color15   = "#90817b";
    };

    namedColors = {
      base03 = "color8";
      base02 = "color0";
      base01 = "color10";
      base00 = "color11";
      base0 = "color12";
      base1 = "color14";
      base2 = "color7";
      base3 = "color15";
      yellow = "color3";
      orange = "color9";
      red = "color1";
      magenta = "color5";
      violet = "color13";
      blue = "color4";
      cyan = "color6";
      green = "color2";
    };

    terminal = {
      bg = "base03";
      fg = "base0";
      cursorBg = "blue";
      cursorFg = "base03";
      selectionBg = "base01";
      selectionFg = "base03";
    };

    pkgThemes.kitty = {

      foreground = "base2";
      background = "base03";

      url_color = "blue";
      tab_bar_background = "base2";
      active_tab_background = "green";
      active_tab_foreground = "base3";
      inactive_tab_background = "base01";
      inactive_tab_foreground = "base3";
    };
  };
}
