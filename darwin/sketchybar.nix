{ pkgs, ... }:
let

  barColors = pkgs.writeScriptBin "colors.sh" 
    ''
#!/bin/bash

# Color Palette
export BLACK=0xff000000
export WHITE=0xffcad3f5
export RED=0xffed8796
export GREEN=0xffa6da95
export BLUE=0xff8aadf4
export YELLOW=0xffeed49f
export ORANGE=0xfff5a97f
export MAGENTA=0xffc6a0f6
export GREY=0xff939ab7
export TRANSPARENT=0x00000000

# General bar colors
export BAR_COLOR=$TRANSPARENT
export BAR_BORDER_COLOR=$TRANSPARENT
export ICON_COLOR=$WHITE # Color of all icons
export LABEL_COLOR=$BLACK # Color of all labels
export BACKGROUND_1=$BLACK
export BACKGROUND_2=$BLACK

export POPUP_BACKGROUND_COLOR=$BLACK
export POPUP_BORDER_COLOR=$BLACK

export SHADOW_COLOR=$BLACK
    '';

  icons = pkgs.writeScriptBin "icons.sh" 
    ''
#!/bin/bash

# General Icons
LOADING=􀖇
APPLE=􀣺
PREFERENCES=􀺽
ACTIVITY=􀒓
LOCK=􀒳
BELL=􀋚
BELL_DOT=􀝗

# Git Icons
GIT_ISSUE=􀍷
GIT_DISCUSSION=􀒤
GIT_PULL_REQUEST=􀙡
GIT_COMMIT=􀡚
GIT_INDICATOR=􀂓

# Spotify Icons
SPOTIFY_BACK=􀊎
SPOTIFY_PLAY_PAUSE=􀊈
SPOTIFY_NEXT=􀊐
SPOTIFY_SHUFFLE=􀊝
SPOTIFY_REPEAT=􀊞

# Yabai Icons
YABAI_STACK=􀏭
YABAI_FULLSCREEN_ZOOM=􀏜
YABAI_PARENT_ZOOM=􀥃
YABAI_FLOAT=􀢌
YABAI_GRID=􀧍

# Battery Icons
BATTERY_100=􀛨
BATTERY_75=􀺸
BATTERY_50=􀺶
BATTERY_25=􀛩
BATTERY_0=􀛪
BATTERY_CHARGING=􀢋

# Volume Icons
VOLUME_100=􀊩
VOLUME_66=􀊧
VOLUME_33=􀊥
VOLUME_10=􀊡
VOLUME_0=􀊣

# WiFi
WIFI_CONNECTED=􀙇
WIFI_DISCONNECTED=􀙈

# svim
MODE_NORMAL=􀂯
MODE_INSERT=􀂥
MODE_VISUAL=􀂿
MODE_CMD=􀂙
MODE_PENDING=􀈏
    '';

  spaceManagerScript = pkgs.writeScriptBin "space.sh" 
    ''
#!/bin/bash

update() {
  source "${barColors}/bin/colors.sh"
  COLOR=''$BACKGROUND_2
  sketchybar --set ''$NAME icon.highlight=''$SELECTED \
                         label.highlight=''$SELECTED \
                         background.border_color=''$COLOR
}

set_space_label() {
  sketchybar --set ''$NAME icon="''$@" label.color=''$WHITE
}

mouse_clicked() {
  if [ "''$BUTTON" = "right" ]; then
    yabai -m space --destroy ''$SID
  else
    if [ "''$MODIFIER" = "shift" ]; then
      SPACE_LABEL="''$(osascript -e "return (text returned of (display dialog \"Give a name to space ''$NAME:\" default answer \"\" with icon note buttons {\"Cancel\", \"Continue\"} default button \"Continue\"))")"
      if [ ''$? -eq 0 ]; then
        if [ "''$SPACE_LABEL" = "" ]; then
          set_space_label "''${NAME:6}"
        else
          set_space_label "''${NAME:6} (''$SPACE_LABEL)"
        fi
      fi
    else
      yabai -m space --focus ''$SID 2>/dev/null
    fi
  fi
}

case "''$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
    '';

  spaceCreatorScript = pkgs.writeScriptBin "space_creator.sh" 
    ''
#!/bin/bash

if [ "$SENDER" = "space_windows_change" ]; then
  args=(--animate sin 10)

  space="''$(echo "''$INFO" | jq -r '.space')"
  apps="''$(echo "''$INFO" | jq -r '.apps | keys[]')"

  icon_strip=" "
  if [ "''${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" ''$(${icons}/bin/icons.sh "''$app")"
    done <<< "''${apps}"
  else
    icon_strip=" —"
  fi
  args+=(--set space.''$space label="''$icon_strip")

  sketchybar -m "''${args[@]}"
fi
    '';

  wifiScript = pkgs.writeScriptBin "wifi_script.sh" 
    ''
#!/bin/bash

update() {
  source "${icons}/bin/icons.sh"
  INFO="''$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: '  '/ SSID: / {print ''$2}')"
  LABEL="''$INFO (''$(ipconfig getifaddr en0))"
  ICON="''$([ -n "''$INFO" ] && echo "''$WIFI_CONNECTED" || echo "''$WIFI_DISCONNECTED")"

  sketchybar --set ''$NAME icon="''$ICON" label="''$LABEL"
}

click() {
  CURRENT_WIDTH="''$(sketchybar --query ''$NAME | jq -r .label.width)"

  WIDTH=0
  if [ "''$CURRENT_WIDTH" -eq "0" ]; then
    WIDTH=dynamic
  fi

  sketchybar --animate sin 20 --set ''$NAME label.width="''$WIDTH"
}

case "''$SENDER" in
  "wifi_change") update
  ;;
  "mouse.clicked") click
  ;;
esac
    '';

  batteryScript = pkgs.writeScriptBin "battery_script.sh" 
    ''
#!/bin/bash

source "${icons}/bin/icons.sh"
source "${barColors}/bin/colors.sh"

BATTERY_INFO="''$(pmset -g batt)"
PERCENTAGE=''$(echo "''$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=''$(echo "''$BATTERY_INFO" | grep 'AC Power')

if [ ''$PERCENTAGE = "" ]; then
  exit 0
fi

DRAWING=on
COLOR=''$WHITE
case ''${PERCENTAGE} in
  9[0-9]|100) ICON=''$BATTERY_100;
  ;;
  [6-8][0-9]) ICON=''$BATTERY_75;
  ;;
  [3-5][0-9]) ICON=''$BATTERY_50
  ;;
  [1-2][0-9]) ICON=''$BATTERY_25; COLOR=''$ORANGE
  ;;
  *) ICON=''$BATTERY_0; COLOR=''$RED
esac

if [[ ''$CHARGING != "" ]]; then
  ICON=''$BATTERY_CHARGING
  DRAWING=off
fi

LABEL="''$PERCENTAGE%"

sketchybar --set ''$NAME drawing=''$DRAWING icon="''$ICON" icon.color=''$COLOR label="''$LABEL" label.color=''$COLOR
    '';

  calendarScript = pkgs.writeScriptBin "calendar_script.sh" 
    ''
#!/bin/bash

sketchybar --set ''$NAME icon="''$(date '+%a %d %b')" label="''$(date '+%H:%M')"
    '';

  volumeScript = pkgs.writeScriptBin "volume_script.sh" 
    ''
#!/bin/bash

WIDTH=100

volume_change() {
  source "${icons}/bin/icons.sh"
  case ''$INFO in
    [6-9][0-9]|100) ICON=''$VOLUME_100
    ;;
    [3-5][0-9]) ICON=''$VOLUME_66
    ;;
    [1-2][0-9]) ICON=''$VOLUME_33
    ;;
    [1-9]) ICON=''$VOLUME_10
    ;;
    0) ICON=''$VOLUME_0
    ;;
    *) ICON=''$VOLUME_100
  esac

  sketchybar --set volume_icon label=''$ICON

  sketchybar --set ''$NAME slider.percentage=''$INFO \
             --animate tanh 30 --set ''$NAME slider.width=''$WIDTH 

  sleep 2

  # Check wether the volume was changed another time while sleeping
  FINAL_PERCENTAGE=''$(sketchybar --query ''$NAME | jq -r ".slider.percentage")
  if [ "''$FINAL_PERCENTAGE" -eq "''$INFO" ]; then
    sketchybar --animate tanh 30 --set ''$NAME slider.width=0
  fi
}

mouse_clicked() {
  osascript -e "set volume output volume ''$PERCENTAGE"
}

case "''$SENDER" in
  "volume_change") volume_change
  ;;
  "mouse.clicked") mouse_clicked
  ;;
esac
    '';

  volumeClickScript = pkgs.writeScriptBin "volume_click_script.sh"
    ''
#!/bin/bash

WIDTH=100

detail_on() {
  sketchybar --animate tanh 30 --set volume slider.width=''$WIDTH
}

detail_off() {
  sketchybar --animate tanh 30 --set volume slider.width=0
}

toggle_detail() {
  INITIAL_WIDTH=''$(sketchybar --query volume | jq -r ".slider.width")
  if [ "''$INITIAL_WIDTH" -eq "0" ]; then
    detail_on
  else
    detail_off
  fi
}

toggle_devices() {
  which SwitchAudioSource >/dev/null || exit 0
  source "''$CONFIG_DIR/colors.sh"

  args=(--remove '/volume.device\.*/' --set "''$NAME" popup.drawing=toggle)
  COUNTER=0
  CURRENT="''$(SwitchAudioSource -t output -c)"
  while IFS= read -r device; do
    COLOR=''$GREY
    if [ "''${device}" = "''$CURRENT" ]; then
      COLOR=''$WHITE
    fi
    args+=(--add item volume.device.''$COUNTER popup."''$NAME" \
           --set volume.device.''$COUNTER label="''${device}" \
                                        label.color="''$COLOR" \
                 click_script="SwitchAudioSource -s \"''${device}\" && sketchybar --set /volume.device\.*/ label.color=''$GREY --set \''$NAME label.color=''$WHITE --set ''$NAME popup.drawing=off")
    COUNTER=''$((COUNTER+1))
  done <<< "''$(SwitchAudioSource -a -t output)"

  sketchybar -m "''${args[@]}" > /dev/null
}

if [ "''$BUTTON" = "right" ] || [ "''$MODIFIER" = "shift" ]; then
  toggle_devices
else
  toggle_detail
fi
    '';

in

{
  environment.systemPackages = with pkgs; [
    sketchybar
  ];


  services.sketchybar = {

    enable = true;
    config = ''
#!/bin/bash

source "${barColors}/bin/colors.sh"
source "${icons}/bin/icons.sh"

# -------------------------------------------------------------
# --------------------------- GENERAL -------------------------
# -------------------------------------------------------------

FONT="SF Pro" # Needs to have Regular, Bold, Semibold, Heavy and Black variants
PADDINGS=3 # All paddings use this value (icon, label, background)

# Unload the macOS on screen indicator overlay for volume change
launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist > /dev/null 2>&1 &

# Setting up the general bar appearance of the bar
bar=(
  height=45
  color=''$BAR_COLOR
  border_width=2
  border_color=''$BAR_BORDER_COLOR
  shadow=off
  position=top
  sticky=on
  padding_right=10
  padding_left=10
  y_offset=-5
  margin=-2
  topmost=window
)

sketchybar --bar "''${bar[@]}"

# Setting up default values
defaults=(
  updates=when_shown
  icon.font="''$FONT:Bold:14.0"
  icon.color=''$ICON_COLOR
  icon.padding_left=''$PADDINGS
  icon.padding_right=''$PADDINGS
  label.font="''$FONT:Black:12.0"
  label.color=''$LABEL_COLOR
  label.padding_left=''$PADDINGS
  label.padding_right=''$PADDINGS
  padding_right=''$PADDINGS
  padding_left=''$PADDINGS
  background.height=26
  background.corner_radius=9
  background.border_width=2
  popup.background.border_width=2
  popup.background.corner_radius=9
  popup.background.border_color=''$POPUP_BORDER_COLOR
  popup.background.color=''$POPUP_BACKGROUND_COLOR
  popup.blur_radius=20
  popup.background.shadow.drawing=on
  scroll_texts=on
)

sketchybar --default "''${defaults[@]}"

# -------------------------------------------------------------------
# --------------------------- LEFT SIDE -----------------------------
# -------------------------------------------------------------------

# ---------------------------- SPACES ------------------------------

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "''${!SPACE_ICONS[@]}"
do
  sid=''$((''$i+1))

  space=(
    space=''$sid
    icon="''${SPACE_ICONS[i]}"
    icon.padding_left=10
    icon.padding_right=10
    padding_left=2
    padding_right=2
    label.padding_right=20
    icon.highlight_color=''$RED
    label.color=''$WHITE
    label.highlight_color=''$WHITE
    label.font="sketchybar-app-font:Regular:16.0"
    label.y_offset=-1
    background.color=''$BLACK
    background.border_color=''$BLACK
    script="${spaceManagerScript}/bin/space.sh"
  )

  sketchybar --add space space.''$sid left    \
             --set space.''$sid "''${space[@]}" \
             --subscribe space.''$sid mouse.clicked
done

space_creator=(
  icon=􀆊
  icon.font="''$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  click_script='yabai -m space --create'
  script="${spaceCreatorScript}/bin/space_creator.sh"
  icon.color=''$BLACK
)

sketchybar --add item space_creator left               \
           --set space_creator "''${space_creator[@]}"   \
           --subscribe space_creator space_windows_change

# ------------------------------------------------------------------
# ---------------------------- RIGHT -------------------------------
# ------------------------------------------------------------------

# ------------------------ Calendar --------------------------------
calendar=(
  icon=cal
  icon.font="''$FONT:Black:12.0"
  icon.padding_right=0
  icon.color=''$WHITE
  label.color=''$WHITE
  label.width=45
  label.align=right
  padding_left=15
  update_freq=30
  script="${calendarScript}/bin/calendar_script.sh"
)

sketchybar --add item calendar right       \
           --set calendar "''${calendar[@]}" \
           --subscribe calendar system_woke

# ----------------------------- WIFI --------------------------------

wifi=(
  padding_right=7
  label.width=0
  label.color=''$WHITE
  icon="''$WIFI_DISCONNECTED"
  script="${wifiScript}/bin/wifi_script.sh"
)

sketchybar --add item wifi right \
           --set wifi "''${wifi[@]}" \
           --subscribe wifi wifi_change mouse.clicked

# ------------------------------ BATTERY --------------------------

battery=(
  script="${batteryScript}/bin/battery_script.sh"
  icon.font="''$FONT:Regular:19.0"
  label.font="''$FONT:Regular:15.0"
  padding_right=5
  padding_left=0
  update_freq=120
  updates=on
)

sketchybar --add item battery right      \
           --set battery "''${battery[@]}" \
           --subscribe battery power_source_change system_woke


# ------------------------------ VOLUME --------------------------

volume_slider=(
  script="${volumeScript}/bin/volume_script.sh"
  updates=on
  label.drawing=off
  icon.drawing=off
  label.color=''$WHITE
  slider.highlight_color=''$BLUE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=''$GREY
  slider.knob=􀀁
  slider.knob.drawing=on
)

volume_icon=(
  click_script="${volumeClickScript}/bin/volume_click_script.sh"
  padding_left=10
  icon=''$VOLUME_100
  icon.width=0
  icon.align=left
  icon.color=''$GREY
  icon.font="''$FONT:Regular:14.0"
  label.width=25
  label.align=left
  label.font="''$FONT:Regular:14.0"
  label.color=''$WHITE
)

status_bracket=(
  background.color=''$BACKGROUND_1
  background.border_color=''$BACKGROUND_2
)

sketchybar --add slider volume right            \
           --set volume "''${volume_slider[@]}"   \
           --subscribe volume volume_change     \
                              mouse.clicked     \
                                                \
           --add item volume_icon right         \
           --set volume_icon "''${volume_icon[@]}"

sketchybar --add bracket status wifi volume_icon calendar \
           --set status "''${status_bracket[@]}"

sketchybar --update
    '';
  };
}
