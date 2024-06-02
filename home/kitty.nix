{ config, lib, pkgs, ... }:
{
  # Kitty terminal
  programs.kitty.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

  programs.kitty.settings = {
    # https://fsd.it/shop/fonts/pragmatapro/
    font_family = "Hack";
    font_size = "12.0";
    adjust_line_height = "140%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "yes";
    window_padding_width = "10";

    # Tab bar
    tab_bar_edge = "top";
    tab_bar_style = "hidden";
    tab_title_template = "Tab {index}: {title}";
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    tab_activity_symbol = "";
  };

  # Change the style of italic font variants
  programs.kitty.extraConfig = ''

    font_features Hack-Italic +ss06
    font_features Hack-BoldItalic +ss07

    modify_font underline_thickness 400%
    modify_font underline_position 2

    background_opacity 0.85
  '';

  programs.kitty.extras.useSymbolsFromNerdFont = "JetBrainsMono Nerd Font";

  programs.kitty.extras.colors = {

    enable = true;
    sonokai = config.colors.sonokai.pkgThemes.kitty;
  };

  # }}}
}
# vim: foldmethod=marker
