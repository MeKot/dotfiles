{ config, lib, ... }:

let
  inherit (lib) filterAttrs mapAttrs attrNames;
  inherit (config.home) homeDirectory;

  # Fill in from `syncthing device-id` (or the web UI at http://127.0.0.1:8384) on each machine.
  deviceIds = {
    jukebox = "TQTYVJX-IWYLKRD-KWDWOHL-WA5IY3W-CQL5GSN-2FHVGIO-LFYJOAY-GKKQVAW";
    boombox = "NHFZLPU-GPJIMDA-DLSZ5QL-YBG7NOU-2HLC3E7-J2CO2HN-N7KZSOC-ZH3R7QW";
  };

  devices = mapAttrs (_: id: { inherit id; }) (filterAttrs (_: id: id != null) deviceIds);
in
{
  services.syncthing = {
    enable = true;
    settings = {
      inherit devices;
      options.globalAnnounceEnabled = false;
      folders.notes = {
        path = "${homeDirectory}/notes";
        devices = attrNames devices;
      };
    };
  };
}
