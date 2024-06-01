{ config, ... }:

{
  programs.git.enable = true;

  programs.git.extraConfig = {
    diff.colorMoved = "default";
    pull.rebase = true;
  };

  programs.git.ignores = [
    "*~"
    ".DS_Store"
  ];

  programs.git.userEmail = config.home.user-info.email;
  programs.git.userName = config.home.user-info.fullName;

  # Enhanced diffs
  # programs.git.delta.enable = true;
  programs.git.difftastic.enable = true;
  programs.git.difftastic.display = "inline";
}
