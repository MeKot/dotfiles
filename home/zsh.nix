{ pkgs, config, ... }:
let

  inherit (config.home.user-info) nixConfigDirectory;

  cutomPrefix = if (pkgs.stdenv.system == "aarch64-darwin")
    then "$HOME"
    else "${nixConfigDirectory}/configs/zsh";
in
{

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ll = "ls -l";
      c = "clear";
      view = "nvim -R";
      gqs = "git-quick-stats";
      ta = "tmux attach -t";
      tt = "terraform";
      v = "nvim";
      vim = "nvim";
      q = "exit";
      catt = "cat";
      cat = "bat";
      gcam = "git commit -a -m";
      nd = "nix develop -c $SHELL";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
       "git"
       "fzf"
       "kubectl"
       "minikube"
       "z"
      ];

      custom = cutomPrefix;
      theme = "robbyrussell";
    };
  };
}
