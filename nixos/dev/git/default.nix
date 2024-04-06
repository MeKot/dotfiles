{ config
, pkgs
, ...
}: {
  programs.git = {
    enable = true;
    userName = "Ivan Kotegov";
    userEmail = "ivan@kotegov.com";
    extraConfig = {
      init = { defaultBranch = "master"; };
      pull = { rebase = true; };
      push = { autoSetupRemote = true; };
      core = { whitespace = "trailing-space,space-before-tab"; };
    };
  };
}
