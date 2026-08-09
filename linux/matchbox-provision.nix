# First-boot overlay for matchbox.
#
# A card flashed from the real config can't be reached: eth0 is pinned to the point-to-point link
# with jukebox, the wifi PSK isn't on the card yet, and no account has a password. This variant
# comes up on the router's LAN instead, so the card can be reached over ssh, seeded with the PSK,
# and then switched to plain `.#matchbox`.

{ lib, ... }:

{
  networking.interfaces.eth0.ipv4.addresses = lib.mkForce [ ];
  networking.interfaces.eth0.useDHCP = true;

  # The PSK gets seeded by hand once this is up; until then wpa_supplicant would only fail on the
  # missing secrets file.
  networking.wireless.enable = lib.mkForce false;

  # Only applied when the account is first created, so change both with `passwd` after logging in.
  users.users.admin.initialPassword = "matchbox";
  users.users.root.initialPassword = "matchbox";
}
