# ASRock A620I Lightning WiFi (AM5) / Ryzen 5 7600X / RTX 4070 SUPER.
# Lives on the wired LAN with Wake-on-LAN armed so `matchbox` can bring it up remotely.

{ lib, pkgs, ... }:

let
  # Check with `ip -br link`: the board's 2.5GbE Realtek shows up as an `enp*` device. The same
  # interface's MAC is what `mekot.wakeOnLan.targets.jukebox.mac` on matchbox has to point at.
  wiredInterface = "enp8s0";
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

  # Build matchbox's closure here — a Pi Zero 2 W can't realistically build its own.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;

  # Networking -------------------------------------------------------------------------------------

  networking.networkmanager.enable = true;

  # Only arms the NIC. The firmware also needs "PCIE Devices Power On" enabled and ErP disabled,
  # otherwise the card is dead once the machine is in S5.
  networking.interfaces.${wiredInterface}.wakeOnLan.enable = true;

  # The wired port isn't a route to the internet — it's a point-to-point link to matchbox, which is
  # what the magic packet travels over. No gateway here, so wifi stays the default route.
  networking.networkmanager.ensureProfiles.profiles.matchbox-link = {

    connection = {
      id = "matchbox-link";
      type = "ethernet";
      interface-name = wiredInterface;
    };

    ipv4 = {
      method = "manual";
      address1 = "192.168.100.2/24";
      never-default = true;
    };

    ipv6.method = "disabled";
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

  environment.systemPackages = lib.attrValues { inherit (pkgs) ethtool; };

  system.stateVersion = "26.05";
}
