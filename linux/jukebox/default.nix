{ lib, pkgs, ... }:

let
  wiredInterface = "enp8s0";
  linkAddress = "192.168.250.2/24";
in
{
  imports = [
    ./hardware-configuration.nix
    ./gaming.nix
    ../common.nix
  ];

  # Boot -------------------------------------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;

  # Networking -------------------------------------------------------------------------------------

  networking.networkmanager.enable = true;

  networking.interfaces.${wiredInterface}.wakeOnLan.enable = true;

  networking.networkmanager.ensureProfiles.profiles.matchbox-link = {

    connection = {
      id = "matchbox-link";
      type = "ethernet";
      interface-name = wiredInterface;
    };

    ipv4 = {
      method = "manual";
      address1 = linkAddress;
      never-default = true;
    };

    ipv6.method = "disabled";
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Desktop ----------------------------------------------------------------------------------------

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = lib.attrValues { inherit (pkgs) claude-code ethtool firefox; };

  system.stateVersion = "26.05";
}
