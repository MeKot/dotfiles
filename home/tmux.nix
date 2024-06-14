{ config, lib, pkgs, ... }:
let

  tmux-nova = pkgs.tmuxPlugins.mkTmuxPlugin
    {
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

  programs.tmux = {

    enable = true;
    terminal = "xterm-256color";

    shortcut = "a";
    escapeTime = 0;

    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";

    historyLimit = 50000;
    customPaneNavigationAndResize = true;

    extraConfig = ''
set-option -g status-position top
    '';

    plugins = with pkgs; [
      {
        plugin = tmux-nova;
        extraConfig = ''
set -g @nova-nerdfonts true
set -g @nova-nerdfonts-left 
set -g @nova-nerdfonts-right 

set -g @nova-pane-active-border-style "#44475a"
set -g @nova-pane-border-style "#282a36"

set -g @nova-status-style-bg "#4e432f"
set -g @nova-status-style-fg "#d8dee9"
set -g @nova-status-style-active-bg "#adda78"
set -g @nova-status-style-active-fg "#2e3540"
set -g @nova-status-style-double-bg "#2d3540"

set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
set -g @nova-segment-mode-colors "#312C2B #f08d71"

set -g @nova-segment-whoami "#(whoami)@#h"

set -g @nova-segment-whoami-colors "#312C2B #f08d71"

set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

set -g @nova-rows 0
set -g @nova-segments-0-left "mode"
set -g @nova-segments-0-right "whoami"
        '';
      }
    ];
  };

}
