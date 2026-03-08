{ pkgs, config, ... }:

let
  inherit (config.mekot) colors;

  tmux-nova = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-nova";
    version = "v1.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "o0th";
      repo = "tmux-nova";
      rev = "6c8fc10d3daa03f400ea9000f9321d8332eab229";
      sha256 = "sha256-0LIql8as2+OendEHVqR0F3pmQTxC1oqapwhxT+34lJo=";
    };
    rtpFilePath = "nova.tmux";
  };

in

{
  home.packages = with pkgs; [
    tmux
    tmuxinator
  ];

  xdg.configFile."tmuxinator" = {
    enable = true;
    recursive = true;
    source = ./tmuxinator;
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";

    shortcut = "a";
    escapeTime = 1;

    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";

    historyLimit = 50000;
    customPaneNavigationAndResize = true;

    extraConfig = ''
set -g mouse on
bind-key C-a send-key C-a
bind-key s choose-tree -sZ -O name

bind C-j split-window -v "tmux list-windows | fzf --reverse | awk -F ':' '{print $1;}' | xargs tmux select-window -t"

set-option -g status-position top
set-option -sa terminal-overrides ",xterm*:Tc"
    '';

    plugins = [
      {
        plugin = tmux-nova;
        extraConfig = ''
set -g @nova-nerdfonts true
set -g @nova-nerdfonts-left 
set -g @nova-nerdfonts-right 

set -g @nova-pane-active-border-style "${colors.tmuxPaneActive}"
set -g @nova-pane-border-style "${colors.tmuxPaneBorder}"

set -g @nova-status-style-bg "${colors.tmuxStatusBg}"
set -g @nova-status-style-fg "${colors.tmuxStatusFg}"
set -g @nova-status-style-active-bg "${colors.tmuxActiveBg}"
set -g @nova-status-style-active-fg "${colors.tmuxActiveFg}"
set -g @nova-status-style-double-bg "${colors.tmuxDoubleBg}"

set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
set -g @nova-segment-mode-colors "${colors.surface} ${colors.orange}"

set -g @nova-segment-whoami "#(whoami)@#h"
set -g @nova-segment-whoami-colors "${colors.surface} ${colors.orange}"

set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

set -g @nova-rows 0
set -g @nova-segments-0-left "mode"
set -g @nova-segments-0-right "whoami"
        '';
      }
    ];
  };
}
