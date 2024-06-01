{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    
     neovim
     python311Packages.pynvim

  ];

  programs.neovim = {

  };

}
