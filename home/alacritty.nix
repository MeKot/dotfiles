{ pkgs, config, ... }:

let
  inherit (config.mekot) colors;
  inherit (config.xdg) configHome;

  # Alacritty uses "0xhex" format (no '#')
  a = c: "0x${builtins.substring 1 6 c}";

  tomlFormat = pkgs.formats.toml { };

  mkColors = colors: {
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
in

{
  # Values are declarative; `mekot-theme` live-toggles which is active by overwriting
  # theme-current.toml and pushing it via IPC (live_config_reload ignores imported files).
  xdg.configFile."alacritty/themes/dark.toml".source =
    tomlFormat.generate "alacritty-theme-dark" { colors = mkColors colors.dark; };
  xdg.configFile."alacritty/themes/light.toml".source =
    tomlFormat.generate "alacritty-theme-light" { colors = mkColors colors.light; };

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [ "${configHome}/alacritty/theme-current.toml" ];
        live_config_reload = true;
      };

      font = {
        normal.family = "IosevkaMeKot Nerd Font";
        size = 15;
      };

      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };

      window = {
        decorations = "buttonless";
        padding.x = 1;
      };
    };
  };
}
