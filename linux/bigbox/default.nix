{ lib, pkgs, config, ... }:

let
  isolatedCpus = "TODO";

  isolationParams = [
    "isolcpus=${isolatedCpus}"
    "nohz_full=${isolatedCpus}"
  ];
in
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  # Boot ---------------------------------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  specialisation = {

    nosmt.configuration = {
      boot.kernelParams = [ "nosmt" ];
    };

    isolated.configuration = {
      boot.kernelParams = isolationParams;
    };

    nosmt-isolated.configuration = {
      boot.kernelParams = [ "nosmt" ] ++ isolationParams;
    };
  };

  # Automatic NUMA balancing migrates pages behind the program's back
  boot.kernel.sysctl."kernel.numa_balancing" = 0;

  powerManagement.cpuFreqGovernor = "performance";

  hardware.enableRedistributableFirmware = true;

  # Networking -----------------------------------------------------------------------------------

  networking.networkmanager.enable = true;

  # Scheduled jobs from common.nix could fire at a bad time
  nix.gc.automatic = lib.mkForce false;
  nix.optimise.automatic = lib.mkForce false;

  # Performance / diagnostics -------------------------------------------------------------------

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      numactl hwloc msr-tools pciutils smartmontools likwid dmidecode perf intel-cmt-cat;
    inherit (config.boot.kernelPackages) turbostat;
  };

  system.stateVersion = "26.05";
}
