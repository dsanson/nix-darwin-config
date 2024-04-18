#!/bin/sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.


case "$SENDER" in
  "mouse.entered"|"mouse.exited"|mouse.exited.global)
    DIR=$(dirname "$0")
    "$DIR"/mouse_over.sh 
    ;;
esac

if  [ "$SENDER" = "wifi_change" ]; then
  WIFI=${INFO:-"Not Connected"}
else
  WIFI=$(networksetup -getairportnetwork en0 | cut -c 24-)
fi

if [ "$WIFI" = "Not Connected" ]; then
  icon="󰖪"
else
  icon="󰖩"
fi

sketchybar --set "$NAME" \
           icon="$icon" \
           --set "${NAME}-info" \
             label="$WIFI"
