#!/usr/bin/env bash
#PATH="/Users/desanso/.nix-profile/bin/:$PATH"

#source ../colors.sh

if [ "$SELECTED" = "true" ] || [ "$SENDER" = "mouse.entered" ]; then
  HIGHLIGHT="on"
  BG_COLOR=$SELECTED_COLOR
else 
  HIGHLIGHT="off"
  BG_COLOR=$UNSELECTED_COLOR
fi

OPTIONS=(
  label.highlight=$HIGHLIGHT
  icon.background.color=$BG_COLOR
)

sketchybar --set $NAME "${OPTIONS[@]}"

