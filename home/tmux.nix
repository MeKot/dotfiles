{ config, lib, pkgs, ... }:
{

  programs.tmux.enable = true;
  programs.tmux.terminal = "tmux-direct";

  programs.tmux.shortcut = "a";
  programs.tmux.escapeTime = 0;

  programs.tmux.historyLimit = 50000;
  programs.tmux.customPaneNavigationAndResize = true;
}
