{ lib, ... }:

# Single source of truth for the mekot color palette (`config.mekot.colors.dark`/`.light`).
# Values are static; which one is *active* is a live toggle — see `home/theme.nix`.
#
# Terminal ANSI slot convention used throughout:
#   slot 0 = darkest   (black)
#   slot 1 = red       slot 5 = violet  (magenta slot, reused Solarized-style)
#   slot 2 = green     slot 6 = orange  (cyan slot, reused Solarized-style)
#   slot 3 = yellow    slot 7 = fg (white)
#   slot 4 = blue      slots 8-15 = bright variants

{
  options.mekot.colors = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf (lib.types.strMatching "#[0-9a-fA-F]{6}"));
    readOnly = true;
    description = ''
      mekot color palettes — single source of truth for all app themes. `dark` and `light`, each
      with the same set of keys.
    '';
    default = {

      # ---- Dark (the original palette) -----------------------------------------------------------

      dark = {
        # Monotone scale (darkest to lightest)
        darkest  = "#1f1e1c";   # absolute darkest bg; ANSI black (slot 0)
        bg       = "#242120";   # terminal background
        surface  = "#312c2b";   # elevated surface, separator background
        tone     = "#393230";   # secondary surface
        muted    = "#6a5e59";   # dim content; ANSI brblack (slot 8)
        subtle   = "#90817b";   # secondary text, comments
        fg       = "#e4e3e1";   # primary text; terminal foreground

        # Accents (ANSI slots 1-6, Solarized-style slot assignment)
        red      = "#af4049";   # ANSI slot 1
        green    = "#a6cd77";   # ANSI slot 2
        yellow   = "#f0c66f";   # ANSI slot 3
        blue     = "#81d0c9";   # ANSI slot 4
        violet   = "#9fa0e1";   # ANSI slot 5 (magenta slot)
        orange   = "#f08d71";   # ANSI slot 6 (cyan slot)

        # Bright accents (ANSI slots 9-14)
        brRed    = "#e02b38";
        brGreen  = "#a6cd77";   # same as green
        brYellow = "#b38b42";
        brBlue   = "#4abab0";
        brViolet = "#9fa0e1";   # same as violet
        brOrange = "#f08d71";   # same as orange

        # Nvim-specific accents (not in ANSI terminal palette)
        nvimRed  = "#f86882";   # brighter red for diagnostics / diff removal
        cyan     = "#2aa198";   # true cyan for nvim (string escapes, etc.)

        # Cursor
        cursorBg = "#e4e3e1";
        cursorFg = "#242120";
      };

      # ---- Light ("bright sunny day" companion) --------------------------------------------------
      # Warm cream bg (less glare than stark white); accents re-tuned darker/more saturated than
      # dark mode's pastel originals so they still have contrast on a light background.

      light = {
        darkest  = "#2a2115";
        bg       = "#f5efe3";
        surface  = "#ece3d2";
        tone     = "#ddd0b8";
        muted    = "#a89478";
        subtle   = "#7a6a55";
        fg       = "#3a2f22";

        red      = "#b3313f";
        green    = "#45700f";
        yellow   = "#a97a17";
        blue     = "#1a7d73";
        violet   = "#4a4da3";
        orange   = "#c1522f";

        brRed    = "#c41e2e";
        brGreen  = "#45700f";   # same as green
        brYellow = "#8a6415";
        brBlue   = "#0f6f66";
        brViolet = "#4a4da3";   # same as violet
        brOrange = "#c1522f";   # same as orange

        nvimRed  = "#c22c46";
        cyan     = "#1c7a72";

        cursorBg = "#3a2f22";
        cursorFg = "#f5efe3";
      };
    };
  };
}
