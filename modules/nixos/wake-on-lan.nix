{ config, lib, pkgs, ... }:

let
  inherit (lib)
    attrValues
    getExe
    mapAttrs
    mapAttrs'
    mkOption
    nameValuePair
    optionalString
    types
    ;

  cfg = config.mekot.wakeOnLan;

  mkWakeScript = name: target: pkgs.writeShellApplication {

    name = "wake-${name}";
    runtimeInputs = attrValues { inherit (pkgs) bash coreutils wakeonlan; };
    text = ''
      echo "Waking ${name} (${target.mac}) on ${target.broadcast}"
      wakeonlan -i ${target.broadcast} ${target.mac}
    ''
    + optionalString (target.hostName != null) ''

      waited=0
      while [ "$waited" -lt ${toString target.timeout} ]; do
        if timeout 1 bash -c "echo > /dev/tcp/${target.hostName}/${toString target.waitPort}" \
             2> /dev/null; then
          echo "${target.hostName} is up after ''${waited}s"
          exit 0
        fi
        sleep 1
        waited=$((waited + 1))
      done
      echo "${target.hostName} did not answer on port ${toString target.waitPort} within" \
        "${toString target.timeout}s" >&2
      exit 1
    '';
  };

  scripts = mapAttrs mkWakeScript cfg.targets;

in
{
  options.mekot.wakeOnLan.targets = mkOption {

    default = { };
    description = ''
      Machines this host can wake. Each entry `foo` gets a `wake-foo` command on `PATH` and a
      `wake-foo.service` unit, so it can be triggered over plain SSH or with `systemctl start`.

      The magic packet is a link-local broadcast: sender and target must share a broadcast domain,
      and the target's NIC needs Wake-on-LAN armed (see `networking.interfaces.*.wakeOnLan`) plus
      the matching BIOS setting.
    '';
    example = { jukebox.mac = "aa:bb:cc:dd:ee:ff"; };
    type = types.attrsOf (types.submodule {

      options = {

        mac = mkOption {
          type = types.strMatching "([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}";
          description = "MAC address of the target's wired interface.";
        };

        broadcast = mkOption {
          type = types.str;
          default = "255.255.255.255";
          description = "Address to broadcast the magic packet to.";
        };

        hostName = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "If set, `wake-<name>` waits for this host to accept connections.";
        };

        waitPort = mkOption {
          type = types.port;
          default = 22;
          description = "Port polled to decide the target is awake.";
        };

        timeout = mkOption {
          type = types.ints.positive;
          default = 120;
          description = "Seconds to wait for the target before giving up.";
        };
      };
    });
  };

  config = {

    environment.systemPackages = attrValues scripts;

    systemd.services = mapAttrs' (name: script: nameValuePair "wake-${name}" {

      description = "Send a Wake-on-LAN magic packet to ${name}";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = getExe script;
      };
    }) scripts;
  };
}
