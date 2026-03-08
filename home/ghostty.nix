{ lib, pkgs, ... }:
{

  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null; # Installed via Homebrew

    enableZshIntegration = true;

    settings = {
      font-family = "IosevkaMeKot Nerd Font";
      font-size = 15;

      # Base16 Bright - Chris Kempson (http://chriskempson.com)
      background = "242120";
      foreground = "e4e3e1";
      cursor-color = "e4e3e1";
      cursor-text = "242120";

      palette = [
        "0=1f1e1c"
        "1=af4049"
        "2=a6cd77"
        "3=f0c66f"
        "4=81d0c9"
        "5=9fa0e1"
        "6=f08d71"
        "7=e4e3e1"
        "8=6a5e59"
        "9=e02b38"
        "10=a6cd77"
        "11=b38b42"
        "12=4abab0"
        "13=9fa0e1"
        "14=f08d71"
        "15=e4e3e1"
      ];

      macos-titlebar-style = "hidden";
      window-padding-x = 1;
    };
  };
}
