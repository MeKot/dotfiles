# Raspberry Pi 3. Always on, headless, and wired straight into jukebox so it can broadcast the magic
# packet that wakes it: `ssh matchbox wake-jukebox`.
#
# Wifi carries the internet on both machines. The ethernet cable between them is a private
# point-to-point link with no gateway, which is what keeps the wake path off the router entirely.
# 1 GB of RAM and an SD card, so nothing graphical and no local builds — see the deploy notes in
# CLAUDE.md for building its closure on jukebox.

{ modulesPath, ... }:

let
  linkPrefix = "192.168.100";
in
{
  imports = [
    # Bootloader (u-boot/extlinux), root filesystem, and the `system.build.sdImage` target used to
    # flash the card in the first place.
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ./common.nix
  ];

  # That image module drags in the installer profile — rescue tools, half a dozen filesystem
  # drivers and ZFS. None of it belongs on an SD card this small.
  disabledModules = [ "profiles/base.nix" ];

  sdImage.compressImage = false;

  # Wake-on-LAN ------------------------------------------------------------------------------------

  # `wake-jukebox` and `systemctl start wake-jukebox`. The MAC is jukebox's wired NIC:
  # `cat /sys/class/net/<iface>/address` there. Broadcasting to the link rather than the default
  # 255.255.255.255 matters — the latter follows the default route and leaves over wifi.
  mekot.wakeOnLan.targets.jukebox = {
    mac = "aa:bb:cc:dd:ee:ff";
    broadcast = "${linkPrefix}.255";
    hostName = "${linkPrefix}.2";
  };

  # Networking -------------------------------------------------------------------------------------

  # One wifi and one wired interface, so the predictable names buy nothing over wlan0/eth0.
  networking.usePredictableInterfaceNames = false;

  networking.useDHCP = false;
  networking.interfaces.wlan0.useDHCP = true;

  # Static, and deliberately without a gateway: the default route comes from wifi.
  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "${linkPrefix}.1";
      prefixLength = 24;
    }
  ];

  networking.wireless = {

    enable = true;

    # Keeps the PSK out of the nix store. Before first boot, mount the card's root partition and:
    #   printf 'home_psk=<psk>\n' > /var/lib/wpa_supplicant/secrets && chmod 600 <same file>
    secretsFile = "/var/lib/wpa_supplicant/secrets";
    networks."CHANGEME-SSID".pskRaw = "ext:home_psk";
  };

  hardware.enableRedistributableFirmware = true;

  # Fitting on an SD card --------------------------------------------------------------------------

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  documentation.enable = false;

  nix.settings.max-jobs = 1;

  system.stateVersion = "26.05";
}
