{ lib, pkgs, config, ... }:

# Palette values are declarative (home/colors.nix); which one is active is a live runtime toggle
# instead, so it works over SSH with no rebuild — see STATE_FILE below.

let
  colors = config.mekot.colors;
  inherit (config.xdg) configHome stateHome;
  inherit (config.mekot) tmuxNovaScript;

  mekotThemeScript = pkgs.writeShellApplication {
    name = "mekot-theme";
    runtimeInputs = [ pkgs.coreutils pkgs.gawk pkgs.tmux ]
      ++ lib.optional pkgs.stdenv.isLinux pkgs.procps
      ++ lib.optional config.programs.alacritty.enable pkgs.alacritty;
    text = ''
      STATE_FILE="${stateHome}/mekot/theme"
      GHOSTTY_THEME_FILE="${configHome}/ghostty/theme-current.conf"
      ALACRITTY_THEME_FILE="${configHome}/alacritty/theme-current.toml"
      ALACRITTY_THEMES_DIR="${configHome}/alacritty/themes"

      mode_arg=''${1:-}

      case "$mode_arg" in
        dark|light)
          mode="$mode_arg"
          ;;
        toggle)
          mode="dark"
          if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "dark" ]; then
            mode="light"
          fi
          ;;
        status)
          if [ -f "$STATE_FILE" ]; then cat "$STATE_FILE"; else echo dark; fi
          exit 0
          ;;
        sync)
          mode="dark"
          if [ -f "$STATE_FILE" ]; then mode="$(cat "$STATE_FILE")"; fi
          ;;
        *)
          echo "usage: mekot-theme <dark|light|toggle|status|sync>" >&2
          exit 1
          ;;
      esac

      mkdir -p "$(dirname "$STATE_FILE")"
      printf '%s' "$mode" > "$STATE_FILE"

      # SIGUSR2 makes Ghostty reload config from disk. Not using pgrep/pkill: on macOS they fail to
      # see/signal Ghostty (a TCC/process-visibility quirk) even though ps + kill work fine.
      mkdir -p "$(dirname "$GHOSTTY_THEME_FILE")"
      printf 'theme = mekot-%s\n' "$mode" > "$GHOSTTY_THEME_FILE"
      ghostty_pid="$(ps -Ao pid=,ucomm= | awk '$2 == "ghostty" { print $1; exit }')"
      if [ -n "$ghostty_pid" ]; then
        kill -s USR2 "$ghostty_pid" 2>/dev/null || true
      fi

      # live_config_reload doesn't watch imported files, so we push colors via IPC instead; the
      # file is still refreshed too, so *new* windows start correctly themed.
      mkdir -p "$(dirname "$ALACRITTY_THEME_FILE")"
      if [ -f "$ALACRITTY_THEMES_DIR/''${mode}.toml" ]; then
        # `cat >` rather than `cp`: the source is a read-only nix store file and `cp` preserves
        # its permission bits, which would leave $ALACRITTY_THEME_FILE unwritable on the next run.
        cat "$ALACRITTY_THEMES_DIR/''${mode}.toml" > "$ALACRITTY_THEME_FILE"
        alacritty_running="$(ps -Ao ucomm= | awk '$1 == "alacritty" { print "1"; exit }')"
        if command -v alacritty >/dev/null 2>&1 && [ -n "$alacritty_running" ]; then
          alacritty msg config "$(cat "$ALACRITTY_THEME_FILE")" || true
        fi
      fi

      # tmux-nova bakes colors into the status-line once when its script runs, so re-run it after
      # setting @nova-*. Checking for a live server (not $TMUX) also recolors tmux from a plain shell.
      if tmux list-sessions >/dev/null 2>&1; then
        if [ "$mode" = "dark" ]; then
          surface="${colors.dark.surface}"
          subtle="${colors.dark.subtle}"
          orange="${colors.dark.orange}"
          bg="${colors.dark.bg}"
          darkest="${colors.dark.darkest}"
          muted="${colors.dark.muted}"
        else
          surface="${colors.light.surface}"
          subtle="${colors.light.subtle}"
          orange="${colors.light.orange}"
          bg="${colors.light.bg}"
          darkest="${colors.light.darkest}"
          muted="${colors.light.muted}"
        fi

        tmux set-option -g @nova-pane-active-border-style "$orange"
        tmux set-option -g @nova-pane-border-style "$muted"
        tmux set-option -g @nova-status-style-bg "$surface"
        tmux set-option -g @nova-status-style-fg "$subtle"
        tmux set-option -g @nova-status-style-active-bg "$orange"
        tmux set-option -g @nova-status-style-active-fg "$bg"
        tmux set-option -g @nova-status-style-double-bg "$darkest"
        tmux set-option -g @nova-segment-mode-colors "$surface $orange"
        tmux set-option -g @nova-segment-whoami-colors "$surface $orange"
        tmux run-shell "${tmuxNovaScript}"
      fi

      # Neovim picks this up itself via an fs_event watch on $STATE_FILE — nothing to do here.

      echo "theme: $mode"
    '';
  };
in

{
  home.packages = [ mekotThemeScript ];

  # Re-derive the per-app files from the state file on every rebuild too, so activation doesn't
  # reset your current choice — seeds `dark` only if the state file doesn't exist yet.
  home.activation.mekotTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${mekotThemeScript}/bin/mekot-theme sync
  '';
}
