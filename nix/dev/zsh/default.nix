{ config
, pkgs
, user
, ...
}: {
  programs.zsh = {
    enable = true;
    shellAliases = {

      nd = "nix develop";

      alias c="clear";
      alias vim="nvim";
      alias view="nvim -R";
      alias gqs="git-quick-stats";
      alias ta="tmux attach -t";
      alias tt="terraform";
      alias v="nvim";
      alias q="exit";
      alias zshconfig="nvim ~/.zshrc";
      alias catt="cat";
      alias cat="bat";
      alias gcam="git commit -a -S -m";
    };

    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      plugins = [

        "git"
	"fzf"
        "tmux"
        "colorize"
        "cp"
      ];
    };
  };
}
