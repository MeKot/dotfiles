{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "admin";
  home.homeDirectory = "/home/admin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    zsh
    fzf
    git
    git-crypt
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/admin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

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
