{ config, ... }:

# TODO: finish tweaking the colors
{

  colors.sonokai = {

    colors = {
      color0    = "#242120";
      color1    = "#f86882";
      color2    = "#a6cd77";
      color3    = "#f0c66f";
      color4    = "#81d0c9";
      color5    = "#55393d";
      color6    = "#2aa198";
      color7    = "#e4e3e1";
      color8    = "#1f1e1c";
      color9    = "#f08d71";
      color10   = "#312c2b";
      color11   = "#393230";
      color12   = "#413937";
      color13   = "#9fa0e1";
      color14   = "#49403c";
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
