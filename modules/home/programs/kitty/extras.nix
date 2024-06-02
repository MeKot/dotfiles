{ config, lib, pkgs, ... }:


let
  inherit (lib) generators concatStringsSep mkIf mkOption optionalAttrs types;

  cfg = config.programs.kitty.extras;

  # Create a Kitty config string from a Nix set
  setToKittyConfig = with generators; toKeyValue { mkKeyValue = mkKeyValueDefault { } " "; };

  # Write a Nix set representing a kitty config into the Nix store
  writeKittyConfig = fileName: config: pkgs.writeTextDir "${fileName}" (setToKittyConfig config);

  # Path in Nix store containing sonokai kitty color configs
  kitty-colors = pkgs.symlinkJoin {
    name = "kitty-colors";
    paths = [
      (writeKittyConfig "sonokai.conf" cfg.colors.sonokai)
    ];
  };

  # Shell scripts for changing Kitty colors
  term-sonokai = pkgs.writeShellScriptBin "term-sonokai" ''
    if [ -n "$KITTY_WINDOW_ID" ]; then
      kitty @ --to $KITTY_LISTEN_ON set-colors --all --configured \
        ${kitty-colors}/sonokai.conf &
    fi
  '';

  socket = "unix:/tmp/mykitty";

in
{

  options.programs.kitty.extras = {

    colors = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When enable, commands <command>term-sonokai</command> will force the sonokai colorscheme,
               should be easy to add more later
          '';
      };

      sonokai = mkOption {
        type = with types; attrsOf str;
        default = { };
        description = ''
          Kitty color settings for sonokai background colorscheme.
          '';
      };

      default = mkOption {
        type = types.enum [ "sonokai" ];
        default = "sonokai";
        description = ''
          The colorscheme Kitty opens with.
          '';
      };
    };

    useSymbolsFromNerdFont = mkOption {
      type = types.str;
      default = "";
      example = "JetBrainsMono Nerd Font";
      description = ''
        NerdFont patched fonts frequently suffer from rendering issues in terminals. To mitigate
        this, we can use a non-NerdFont with Kitty and use the <literal>symbol_map</literal> setting
        to tell Kitty to only use a NerdFont for NerdFont symbols.

        Set this option the name of an installed NerdFont (the same name you'd use in the
        <literal>font_family</literal> setting), to enable this feature.
      '';
    };
  };

  config = mkIf config.programs.kitty.enable {

    home.packages = mkIf cfg.colors.enable [
      term-sonokai
    ];

    programs.kitty.settings = optionalAttrs cfg.colors.enable
      (
        cfg.colors.${cfg.colors.default} // {
          allow_remote_control = "yes";
          listen_on = socket;
        }
      ) // optionalAttrs (cfg.useSymbolsFromNerdFont != "") {

      # https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
      symbol_map = concatStringsSep "," [
        # Seti-UI + Custom
        "U+E5FA-U+E6AC"
        # Devicons
        "U+E700-U+E7C5"
        # Font Awesome
        "U+F000-U+F2E0"
        # Font Awesome Extension
        "U+E200-U+E2A9"
        # Material Design Icons
        "U+F0001-U+F1AF0"
        # Weather
        "U+E300-U+E3E3"
        # Octicons
        "U+F400-U+F532"
        "U+2665"
        "U+26A1"
        # Powerline Symbols
        "U+E0A0-U+E0A2"
        "U+E0B0-U+E0B3"
        # Powerline Extra Symbols
        "U+E0A3"
        "U+E0B4-U+E0C8"
        "U+E0CA"
        "U+E0CC-U+E0D2"
        "U+E0D4"
        # IEC Power Symbols
        "U+23FB-U+23FE"
        "U+2B58"
        # Font Logos
        "U+F300-U+F32F"
        # Pomicons
        "U+E000-U+E00A"
        # Codicons
        "U+EA60-U+EBEB"
        # Heavy Angle Brackets
        "U+276C-U+2771"
        # Box Drawing
        "U+2500-U+259F"
      ] + " ${cfg.useSymbolsFromNerdFont}";
    };

    programs.kitty.darwinLaunchOptions = mkIf pkgs.stdenv.isDarwin [
      "--listen-on ${socket}"
    ];

  };

}
