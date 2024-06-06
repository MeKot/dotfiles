{ config, lib, pkgs, ... }:
{

  programs.alacritty = {
     enable = true;
     settings = {
       live_config_reload = false;
       font = {
         normal.family = "Iosevka";
         size = 14;
       };

       shell = {
         program = "${pkgs.zsh}/bin/zsh";
       };
 
       # Base16 Bright - alacritty color config
       # Chris Kempson (http://chriskempson.com)
       colors = {
         # Default colors
         primary = {
           background = "0x000000";
           foreground = "0xe0e0e0";
         };
 
         # Colors the cursor will use if `custom_cursor_colors` is true
         cursor = {
           text= "0x000000";
           cursor= "0xe0e0e0";
         };
 
         # Normal colors
         normal = {
           black=   "0x000000";
           red=     "0xfb0120";
           green=   "0xa1c659";
           yellow=  "0xfda331";
           blue=    "0x6fb3d2";
           magenta= "0xd381c3";
           cyan=    "0x76c7b7";
           white=   "0xe0e0e0";
         };
 
         # Bright colors
         bright = {
           black=   "0xb0b0b0";
           red=     "0xfc6d24";
           green=   "0x303030";
           yellow=  "0x505050";
           blue=    "0xd0d0d0";
           magenta= "0xf5f5f5";
           cyan=    "0xbe643c";
           white=   "0xffffff";
         };
       };
 
       draw_bold_text_with_bright_colors = true;
     };
   };
}
