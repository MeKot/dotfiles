{ lib, pkgs, config, ... }:

let
  # Placeholder — real core IDs aren't known until bigbox is installed and `lscpu -e` shows the
  # actual CPU->NODE mapping. Pick 2 physical cores per NUMA node (skip CPU 0) and replace this.
  isolatedCpus = "TODO";
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

  # SMT/Hyper-Threading off in software rather than a BIOS toggle, so it stays declarative and
  # reviewable. With nosmt applied, isolatedCpus above refers to physical core IDs, not siblings.
  boot.kernelParams = [
    "nosmt"
    "isolcpus=${isolatedCpus}"
  ];

  hardware.enableRedistributableFirmware = true;

  # Networking -----------------------------------------------------------------------------------

  networking.networkmanager.enable = true;

  # Performance / diagnostics -------------------------------------------------------------------

  environment.systemPackages = lib.attrValues {
    inherit (pkgs) numactl hwloc msr-tools pciutils smartmontools likwid;
    inherit (config.boot.kernelPackages) turbostat;
  };

  system.stateVersion = "26.05";
}
