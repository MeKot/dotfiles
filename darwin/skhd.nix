{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    skhd
  ];

  services.skhd = {
    enable = true;
    
    snkdhConfig = ''
      # focus window
      alt - h : yabai -m window --focus west
      alt - l : yabai -m window --focus east
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      
      # swap managed window
      shift + alt - h : yabai -m window --swap west
      shift + alt - l : yabai -m window --swap east
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      
      # balance size of windows
      shift + alt - 0 : yabai -m space --balance
      
      # make floating window fill left-half of screen
      shift + alt - h   : yabai -m window --grid 1:2:0:0:1:1
      
      # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
      shift + cmd - n : yabai -m space --create && \
                         index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \
                         yabai -m window --space "\$\{index}" && \
                         yabai -m space --focus "\$\{index}"
      
      # fast focus desktop
      cmd + alt - x : yabai -m space --focus recent
      cmd + alt - 1 : yabai -m space --focus 1
      cmd + alt - 2 : yabai -m space --focus 2
      cmd + alt - 3 : yabai -m space --focus 3
      cmd + alt - 4 : yabai -m space --focus 4
      cmd + alt - 5 : yabai -m space --focus 5
      cmd + alt - 6 : yabai -m space --focus 6
      cmd + alt - 7 : yabai -m space --focus 7
      cmd + alt - 8 : yabai -m space --focus 8
      cmd + alt - 9 : yabai -m space --focus 9
      
      # send window to desktop and follow focus
      shift + cmd - z : yabai -m window --space next; yabai -m space --focus next
      shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2
      
      # focus monitor
      ctrl + alt - z  : yabai -m display --focus prev
      ctrl + alt - 3  : yabai -m display --focus 3
      
      # send window to monitor and follow focus
      ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
      ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1
      
      # increase window size
      shift + ctrl - h : yabai -m window --resize left:-20:0
      shift + ctrl - l : yabai -m window --resize left:20:0
      shift + ctrl - j : yabai -m window --resize top:0:-20
      shift + ctrl - k : yabai -m window --resize top:0:20
      
      # toggle window zoom
      alt - d : yabai -m window --toggle zoom-parent
      alt - f : yabai -m window --toggle zoom-fullscreen
      
      # toggle window split type
      alt - e : yabai -m window --toggle split
      
      # float / unfloat window and center on screen
      alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2
    '';
  };
}
