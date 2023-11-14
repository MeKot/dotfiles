#!/bin/bash

zen_on() {
  sketchybar --set wifi drawing=off \
             --set calendar icon.drawing=off \
             --set separator drawing=off \
             --set volume_icon drawing=off \
             --set spotify.anchor drawing=off \
             --set spotify.play updates=off \
             --set brew drawing=off \
             --set volume drawing=off \
}

zen_off() {
  sketchybar --set wifi drawing=on \
             --set calendar icon.drawing=on \
             --set separator drawing=on \
             --set volume_icon drawing=on \
             --set spotify.anchor drawing=on \
             --set spotify.play updates=on \
             --set brew drawing=on \
             --set volume drawing=on \
}

if [ "$1" = "on" ]; then
  zen_on
elif [ "$1" = "off" ]; then
  zen_off
else
  if [ "$(sketchybar --query apple.logo | jq -r ".geometry.drawing")" = "on" ]; then
    zen_on
  else
    zen_off
  fi
fi

