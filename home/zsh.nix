{ config, ... }:
let

  inherit (config.home.user-info) nixConfigDirectory;
in
{

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ll = "ls -l --color=auto";
      ls = "ls --color=auto";
      l = "ls -la --color=auto";
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
      csv = "mlr --icsv --opprint";
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

      custom = "${nixConfigDirectory}/configs/zsh";
      theme = "robbyrussell";

      extraConfig = ''
      '';

    };
  };
}
