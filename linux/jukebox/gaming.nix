{ config, lib, pkgs, ... }:

{
  # NVIDIA -----------------------------------------------------------------------------------------

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Proton and most native Linux games ship 32-bit libraries
  };

  hardware.nvidia = {

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Ada Lovelace, so the open kernel modules are the supported path.
    open = true;

    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  # Steam ------------------------------------------------------------------------------------------

  programs.steam = {

    enable = true;
    protontricks.enable = true;
    extraCompatPackages = lib.attrValues { inherit (pkgs) proton-ge-bin; };

    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  # Chat -------------------------------------------------------------------------------------------

  environment.systemPackages = lib.attrValues { inherit (pkgs) discord; };
}
