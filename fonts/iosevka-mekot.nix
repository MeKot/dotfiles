inputs: final: prev:
let

  inherit (inputs) flake-utils;

  allSystems = flake-utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = prev;
        plainPackage = pkgs.iosevka.override {
          privateBuildPlan = builtins.readFile ./iosevka-mekot.toml;
          set = "MeKot";
        };

        nerdFontPackage = let outDir = "$out/share/fonts/truetype/"; in
          pkgs.stdenv.mkDerivation {
            pname = "iosevka-mekot-nerd-font";
            version = plainPackage.version;

            src = builtins.path { path = ./.; name = "iosevka-mekot"; };

            buildInputs = [ pkgs.nerd-font-patcher ];

            configurePhase = "mkdir -p ${outDir}";
            buildPhase = ''
                  for fontfile in ${plainPackage}/share/fonts/truetype/*
                  do
                  nerd-font-patcher $fontfile --complete --careful --outputdir ${outDir}
                  done
                  '';
            dontInstall = true;
          };

        packages = {
          normal = plainPackage;
          nerd-font = nerdFontPackage;
        };
      in
        {
        inherit packages;
        defaultPackage = nerdFontPackage;
      }
    );
in
{
  iosevka-mekot = allSystems.packages.${final.system}.nerd-font; # either `normal` or `nerd-font`
}
