{ lib, ... }:

# Single source of truth for the mekot color palette.
# All apps that need colors should reference `config.mekot.colors.*` from here.
# Colors are defined as hex strings (e.g. "#242120").
#
# Terminal ANSI slot convention used throughout:
#   slot 0 = darkest   (black)
#   slot 1 = red       slot 5 = violet  (magenta slot, reused Solarized-style)
#   slot 2 = green     slot 6 = orange  (cyan slot, reused Solarized-style)
#   slot 3 = yellow    slot 7 = fg (white)
#   slot 4 = blue      slots 8-15 = bright variants

{
  options.mekot.colors = lib.mkOption {
    type = lib.types.attrsOf (lib.types.strMatching "#[0-9a-fA-F]{6}");
    readOnly = true;
    description = "mekot color palette — single source of truth for all app themes.";
    default = let

      # ---- Monotone scale (darkest to lightest) --------------------------------------------------

      darkest  = "#1f1e1c";   # absolute darkest bg; ANSI black (slot 0)
      bg       = "#242120";   # terminal background
      surface  = "#312c2b";   # elevated surface, separator background
      tone     = "#393230";   # secondary surface
      muted    = "#6a5e59";   # dim content; ANSI brblack (slot 8)
      subtle   = "#90817b";   # secondary text, comments
      fg       = "#e4e3e1";   # primary text; terminal foreground

      # ---- Accents (ANSI slots 1-6, Solarized-style slot assignment) ----------------------------

      red      = "#af4049";   # ANSI slot 1
      green    = "#a6cd77";   # ANSI slot 2
      yellow   = "#f0c66f";   # ANSI slot 3
      blue     = "#81d0c9";   # ANSI slot 4
      violet   = "#9fa0e1";   # ANSI slot 5 (magenta slot)
      orange   = "#f08d71";   # ANSI slot 6 (cyan slot)

      # ---- Bright accents (ANSI slots 9-14) -----------------------------------------------------

      brRed    = "#e02b38";
      brGreen  = "#a6cd77";   # same as green
      brYellow = "#b38b42";
      brBlue   = "#4abab0";
      brViolet = "#9fa0e1";   # same as violet
      brOrange = "#f08d71";   # same as orange

      # ---- Nvim-specific accents (not in ANSI terminal palette) ---------------------------------

      nvimRed  = "#f86882";   # brighter red for diagnostics / diff removal
      cyan     = "#2aa198";   # true cyan for nvim (string escapes, etc.)

      # ---- Cursor --------------------------------------------------------------------------------

      cursorBg = "#e4e3e1";
      cursorFg = "#242120";

      # ---- tmux nova status bar -----------------------------------------------------------------

      tmuxStatusBg   = "#4e432f";
      tmuxStatusFg   = "#d8dee9";
      tmuxActiveBg   = "#adda78";
      tmuxActiveFg   = "#2e3540";
      tmuxDoubleBg   = "#2d3540";
      tmuxPaneBorder = "#282a36";
      tmuxPaneActive = "#44475a";

    in {
      inherit darkest bg surface tone muted subtle fg;
      inherit red green yellow blue violet orange;
      inherit brRed brGreen brYellow brBlue brViolet brOrange;
      inherit nvimRed cyan;
      inherit cursorBg cursorFg;
      inherit tmuxStatusBg tmuxStatusFg tmuxActiveBg tmuxActiveFg;
      inherit tmuxDoubleBg tmuxPaneBorder tmuxPaneActive;
    };
  };
}
