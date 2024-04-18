#!/bin/sh

# mouse_over "$NAME" "$SENDER"
case "$SENDER" in
  "mouse.entered")
    sketchybar \
      --set $NAME \
        label.highlight=on  \
        icon.highlight=on \
        popup.drawing=on
  exit
  ;;
"mouse.exited"|"mouse.exited.global")
  sketchybar \
    --set $NAME \
      label.highlight=off \
      icon.highlight=off \
      popup.drawing=off
  exit
  ;;
esac
