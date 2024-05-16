{ config, pkgs, ... }:

{
  home.username = "admin";
  home.homeDirectory = "/home/admin";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    zsh
    fzf
    git
    git-crypt
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    gpg.enable = true;

    zsh = {
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
	q = "exit";
	zshconfig = "nvim ~/.zshrc";
	catt = "cat";
	cat = "bat";
	gcam = "git commit -a -m";
	nixit = "home-manager switch -f ~/git/dotfiles/nixos/users/admin/home.nix";
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
	custom = "$HOME/.oh-my-custom";
	theme = "robbyrussell";
      };
      
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
  };
  };

}
