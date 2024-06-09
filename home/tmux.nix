{ config, lib, pkgs, ... }:
{

  programs.tmux.enable = true;
  programs.tmux.terminal = "xterm-256color";

  programs.tmux.shortcut = "a";
  programs.tmux.escapeTime = 0;

  programs.tmux.historyLimit = 50000;
  programs.tmux.customPaneNavigationAndResize = true;
}
