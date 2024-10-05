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
  sketchybar --set ''$NAME icon="''$@" label.color=''$SELECTED icon.color=''$SELECTED
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

  iconMap = pkgs.writeScriptBin "icon_map.sh"
    ''
case "$1" in
"WhatsApp")
  icon_result=":whats_app:"
  ;;
"Nova")
  icon_result=":nova:"
  ;;
"Signal")
  icon_result=":signal:"
  ;;
"Affinity Photo")
  icon_result=":affinity_photo:"
  ;;
"Sublime Text")
  icon_result=":sublime_text:"
  ;;
"Notion")
  icon_result=":notion:"
  ;;
"Pine")
  icon_result=":pine:"
  ;;
"Alacritty" | "Hyper" | "iTerm2" | "kitty" | "Terminal" | "终端" | "WezTerm")
  icon_result=":terminal:"
  ;;
"Podcasts" | "播客")
  icon_result=":podcasts:"
  ;;
"Spark Desktop")
  icon_result=":spark:"
  ;;
"Dropbox")
  icon_result=":dropbox:"
  ;;
"OmniFocus")
  icon_result=":omni_focus:"
  ;;
"TIDAL")
  icon_result=":tidal:"
  ;;
"Spotlight")
  icon_result=":spotlight:"
  ;;
"Affinity Publisher")
  icon_result=":affinity_publisher:"
  ;;
"Replit")
  icon_result=":replit:"
  ;;
"Kakoune")
  icon_result=":kakoune:"
  ;;
"Code" | "Code - Insiders")
  icon_result=":code:"
  ;;
"Microsoft Excel")
  icon_result=":microsoft_excel:"
  ;;
"League of Legends")
  icon_result=":league_of_legends:"
  ;;
"Obsidian")
  icon_result=":obsidian:"
  ;;
"Typora")
  icon_result=":text:"
  ;;
"Blender")
  icon_result=":blender:"
  ;;
"Microsoft Edge")
  icon_result=":microsoft_edge:"
  ;;
"Caprine")
  icon_result=":caprine:"
  ;;
"Figma")
  icon_result=":figma:"
  ;;
"Folx")
  icon_result=":folx:"
  ;;
"Arc")
  icon_result=":arc:"
  ;;
"TeamSpeak 3")
  icon_result=":team_speak:"
  ;;
"Drafts")
  icon_result=":drafts:"
  ;;
"Jellyfin Media Player")
  icon_result=":jellyfin:"
  ;;
"Element")
  icon_result=":element:"
  ;;
"Numbers" | "Numbers 表格")
  icon_result=":numbers:"
  ;;
"Airmail")
  icon_result=":airmail:"
  ;;
"Preview" | "预览" | "Skim" | "zathura")
  icon_result=":pdf:"
  ;;
"zoom.us")
  icon_result=":zoom:"
  ;;
"IntelliJ IDEA")
  icon_result=":idea:"
  ;;
"Music" | "音乐")
  icon_result=":music:"
  ;;
"Safari" | "Safari浏览器" | "Safari Technology Preview")
  icon_result=":safari:"
  ;;
"Finder" | "访达")
  icon_result=":finder:"
  ;;
"TickTick")
  icon_result=":tick_tick:"
  ;;
"Mattermost")
  icon_result=":mattermost:"
  ;;
"Calendar" | "日历" | "Fantastical" | "Cron" | "Amie")
  icon_result=":calendar:"
  ;;
"Todoist")
  icon_result=":todoist:"
  ;;
"Live")
  icon_result=":ableton:"
  ;;
"Logseq")
  icon_result=":logseq:"
  ;;
"Parallels Desktop")
  icon_result=":parallels:"
  ;;
"App Store")
  icon_result=":app_store:"
  ;;
"ClickUp")
  icon_result=":click_up:"
  ;;
"Docker" | "Docker Desktop")
  icon_result=":docker:"
  ;;
"Trello")
  icon_result=":trello:"
  ;;
"Microsoft To Do" | "Things")
  icon_result=":things:"
  ;;
"Notability")
  icon_result=":notability:"
  ;;
"Brave Browser")
  icon_result=":brave_browser:"
  ;;
"网易云音乐")
  icon_result=":netease_music:"
  ;;
"Messages" | "信息" | "Nachrichten")
  icon_result=":messages:"
  ;;
"DEVONthink 3")
  icon_result=":devonthink3:"
  ;;
"Bear")
  icon_result=":bear:"
  ;;
"Notes" | "备忘录")
  icon_result=":notes:"
  ;;
"GrandTotal" | "Receipts")
  icon_result=":dollar:"
  ;;
"Cypress")
  icon_result=":cypress:"
  ;;
"Sequel Pro")
  icon_result=":sequel_pro:"
  ;;
"Sequel Ace")
  icon_result=":sequel_ace:"
  ;;
"PomoDone App")
  icon_result=":pomodone:"
  ;;
"mpv")
  icon_result=":mpv:"
  ;;
"Orion" | "Orion RC")
  icon_result=":orion:"
  ;;
"System Preferences" | "系统设置")
  icon_result=":gear:"
  ;;
"Reminders" | "提醒事项")
  icon_result=":reminders:"
  ;;
"MoneyMoney")
  icon_result=":bank:"
  ;;
"MAMP" | "MAMP PRO")
  icon_result=":mamp:"
  ;;
"Final Cut Pro")
  icon_result=":final_cut_pro:"
  ;;
"Microsoft PowerPoint")
  icon_result=":microsoft_power_point:"
  ;;
"VLC")
  icon_result=":vlc:"
  ;;
"Chromium" | "Google Chrome" | "Google Chrome Canary")
  icon_result=":google_chrome:"
  ;;
"Xcode")
  icon_result=":xcode:"
  ;;
"Canary Mail" | "HEY" | "Mail" | "Mailspring" | "MailMate" | "邮件")
  icon_result=":mail:"
  ;;
"Vivaldi")
  icon_result=":vivaldi:"
  ;;
"Color Picker" | "数码测色计")
  icon_result=":color_picker:"
  ;;
"Audacity")
  icon_result=":audacity:"
  ;;
"WebStorm")
  icon_result=":web_storm:"
  ;;
"Emacs")
  icon_result=":emacs:"
  ;;
"GitHub Desktop")
  icon_result=":git_hub:"
  ;;
"Setapp")
  icon_result=":setapp:"
  ;;
"微信")
  icon_result=":wechat:"
  ;;
"Alfred")
  icon_result=":alfred:"
  ;;
"Tor Browser")
  icon_result=":tor_browser:"
  ;;
"Skype")
  icon_result=":skype:"
  ;;
"qutebrowser")
  icon_result=":qute_browser:"
  ;;
"Firefox Developer Edition" | "Firefox Nightly")
  icon_result=":firefox_developer_edition:"
  ;;
"Insomnia")
  icon_result=":insomnia:"
  ;;
"LibreWolf")
  icon_result=":libre_wolf:"
  ;;
"Tweetbot" | "Twitter")
  icon_result=":twitter:"
  ;;
"FaceTime" | "FaceTime 通话")
  icon_result=":face_time:"
  ;;
"Zotero")
  icon_result=":zotero:"
  ;;
"1Password 7")
  icon_result=":one_password:"
  ;;
"Slack")
  icon_result=":slack:"
  ;;
"Spotify")
  icon_result=":spotify:"
  ;;
"OBS")
  icon_result=":obsstudio:"
  ;;
"Min")
  icon_result=":min_browser:"
  ;;
"Default")
  icon_result=":default:"
  ;;
"Pi-hole Remote")
  icon_result=":pihole:"
  ;;
"VMware Fusion")
  icon_result=":vmware_fusion:"
  ;;
"CleanMyMac X")
  icon_result=":desktop:"
  ;;
"Telegram")
  icon_result=":telegram:"
  ;;
"Bitwarden")
  icon_result=":bit_warden:"
  ;;
"Iris")
  icon_result=":iris:"
  ;;
"Neovide" | "MacVim" | "Vim" | "VimR")
  icon_result=":vim:"
  ;;
"Warp")
  icon_result=":warp:"
  ;;
"Zulip")
  icon_result=":zulip:"
  ;;
"Thunderbird")
  icon_result=":thunderbird:"
  ;;
"Tower")
  icon_result=":tower:"
  ;;
"Matlab")
  icon_result=":matlab:"
  ;;
"Joplin")
  icon_result=":joplin:"
  ;;
"Android Studio")
  icon_result=":android_studio:"
  ;;
"Keynote" | "Keynote 讲演")
  icon_result=":keynote:"
  ;;
"Grammarly Editor")
  icon_result=":grammarly:"
  ;;
"Firefox")
  icon_result=":firefox:"
  ;;
"Zed")
  icon_result=":zed:"
  ;;
"Sketch")
  icon_result=":sketch:"
  ;;
"Discord" | "Discord Canary" | "Discord PTB")
  icon_result=":discord:"
  ;;
"Evernote Legacy")
  icon_result=":evernote_legacy:"
  ;;
"Zeplin")
  icon_result=":zeplin:"
  ;;
"KeePassXC")
  icon_result=":kee_pass_x_c:"
  ;;
"Microsoft Teams")
  icon_result=":microsoft_teams:"
  ;;
"카카오톡")
  icon_result=":kakaotalk:"
  ;;
"Linear")
  icon_result=":linear:"
  ;;
"Microsoft Word")
  icon_result=":microsoft_word:"
  ;;
"Atom")
  icon_result=":atom:"
  ;;
"Keyboard Maestro")
  icon_result=":keyboard_maestro:"
  ;;
"Transmit")
  icon_result=":transmit:"
  ;;
"Android Messages")
  icon_result=":android_messages:"
  ;;
"Pages" | "Pages 文稿")
  icon_result=":pages:"
  ;;
"Affinity Designer")
  icon_result=":affinity_designer:"
  ;;
"VSCodium")
  icon_result=":vscodium:"
  ;;
"Reeder")
  icon_result=":reeder5:"
  ;;
"Calibre")
  icon_result=":book:"
  ;;
*)
  icon_result=":default:"
  ;;
esac
echo $icon_result
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
      icon_strip+=" ''$(${iconMap}/bin/icon_map.sh "''$app")"
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
  INFO="''$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1; gsub(":",""); print;exit}')"
  LABEL=" "
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
    padding_left=2
    padding_right=2
    icon="''${SPACE_ICONS[i]}"
    icon.padding_left=8
    icon.padding_right=0
    icon.highlight_color=''$RED
    label.color=''$WHITE
    label.highlight_color=''$RED
    label.font="sketchybar-app-font:Regular:16.0"
    label.padding_right=20
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

    extraPackages = with pkgs; [
      jq
    ];
  };

  launchd.user.agents.sketchybar = {
    serviceConfig = {
      StandardOutPath = "/tmp/sketchybar.log";
      StandardErrorPath = "/tmp/sketchybar.log";
    };
  };
}
