{ config, lib, ... }:

{
  options.mekot.slimProfile = lib.mkEnableOption ''
    a trimmed package set for low-powered hosts. Leaves out GUI apps and anything else whose
    closure a Raspberry Pi shouldn't have to fetch, build or store
  '';

  config = lib.mkIf config.mekot.slimProfile {

    # Rendering home-manager's option reference costs more than it's worth on such a host.
    manual.manpages.enable = false;

    # Drops nix-locate and its ~90 MB index. `,` still works — it ships a 1 MB bin-only one.
    programs.nix-index.enable = false;
  };
}
