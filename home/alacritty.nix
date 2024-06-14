{ config, lib, pkgs, ... }:
{

  programs.alacritty = {
     enable = true;
     settings = {
       live_config_reload = false;
       font = {
         normal.family = "Hack Nerd Font";
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
           background = "0x242120";
           foreground = "0xe4e3e1";
         };
 
         # Colors the cursor will use if `custom_cursor_colors` is true
         cursor = {
           text= "0x242120";
           cursor= "0xe4e3e1";
         };
 
         normal = {
           black=   "0x1f1e1c";
           red=     "0xf86882";
           green=   "0xa6cd77";
           yellow=  "0xf0c66f";
           blue=    "0x81d0c9";
           cyan=    "0xf08d71";
           magenta ="0x9fa0e1";
           white=   "0xe4e3e1";
         };
 
         bright = {
           black=   "0x6a5e59";
           red=     "0x55393d";
           green=   "0x394634";
           yellow=  "0x4e432f";
           blue=    "0x354157";
           cyan =   "0xf08d71";
           magenta ="0x9fa0e1";
           white=   "0xe4e3e1";
         };
       };

       window = {
         opacity = 0.8;
         decorations = "buttonless";
       };
     };
   };
}
