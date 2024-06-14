{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yabai
  ];

  services.yabai = {
    enable = true;
    config = {
      
      layout = "bsp";

      top_padding = 8;
      left_padding = 8;
      right_padding = 8;
      bottom_padding = 8;

      window_gap = 8;
      split_ratio = 0.5;
      window_shadow = "float";
      external_bar = "main:5:0";
    };

    extraConfig = '''
	yabai -m signal --add event=dock_did_restart action="yabai --load-sa"
	yabai --load-sa

	yabai -m rule --add app="^System Settings$" manage=off
	yabai -m rule --add app="^Spark$" manage=off
	yabai -m rule --add app="^Spotify$" manage=off
	yabai -m rule --add app="^Finder$" manage=off
	yabai -m rule --add app="^App Store$" manage=off
	yabai -m rule --add app="^Mozilla VPN$" manage=off
	yabai -m rule --add app="^Weather$" manage=off
    ''';
  };
}
