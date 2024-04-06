{ lib, config, pkgs, ... }:

{
  options = {

    main-user.enable = lib.mkEnableOption "enable user module"

    main-user.userName = lib.mkOption {

      default = "admin"
      description = ''
	username
      '';
    }

  };

  config = lib.mkIf config.main-user.enable {
    users.users.${config.main-user.userName} = {
      
      isNormalUser = true;
      initialPassword = "12345";
      description = "Main user";
      shell = pkgs.zsh;
    }
  };
}
