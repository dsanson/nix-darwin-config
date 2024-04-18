#!/bin/sh

# case "$SENDER" in
#   "mouse.entered"|"mouse.exited"|mouse.exited.global)
#     DIR=$(dirname "$0")
#     "$DIR"/mouse_over.sh 
#     ;;
# esac

ON_ICON="󰅶"
OFF_ICON="󰾪"

STATUS="$(pgrep caffeinate)"

if [ "$SENDER" = "mouse.clicked" ]; then
  #echo "clicked"
  if [ "$STATUS" = "" ]; then
    #echo "off to on"
    OPACITY="$(yabai -m config window_opacity)"
    yabai -m config window_opacity off
    sketchybar --set "$NAME" icon="$ON_ICON"
    /usr/bin/caffeinate -d
    yabai -m config window_opacity "$OPACITY"
  else
    #echo "on to off"
    /usr/bin/killall caffeinate
    sketchybar --set "$NAME" icon="$OFF_ICON"
  fi
else
  #echo "forced"
  if [ "$STATUS" = "" ]; then
    #echo "off"
    sketchybar --set "$NAME" icon="$OFF_ICON" 
  else
    #echo "on"
    sketchybar --set "$NAME" icon="$ON_ICON" 
  fi
fi
