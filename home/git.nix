{ config, ... }:

{
  programs.git.enable = true;

  programs.git.settings = {

    user.name = config.home.user-info.fullName;
    user.email = config.home.user-info.email;

    diff.colorMoved = "default";
    pull.rebase = true;
  };

  programs.git.ignores = [
    "*~"
    ".DS_Store"
  ];

  # Enhanced diffs
  # programs.git.delta.enable = true;
  programs.difftastic.enable = true;
  programs.difftastic.git.enable = true;
  programs.difftastic.options.display = "inline";
}
