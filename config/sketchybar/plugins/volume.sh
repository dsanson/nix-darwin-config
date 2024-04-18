#!/bin/sh

case "$SENDER" in
  "mouse.entered"|"mouse.exited"|"mouse.exited.global")
    DIR=$(dirname "$0")
    "$DIR"/mouse_over.sh 
    exit
    ;;
esac

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

VOLUME=$INFO
PADDING=0

case $VOLUME in
  [6-9][0-9]|100) 
    ICON=""
  ;;
  [3-5][0-9]) 
    ICON="󰕾"
  ;;
  [1-9]|[1-2][0-9]) 
    ICON="󰖀"
  ;;
  *) 
    ICON="󰕿"
    PADDING=5

esac

LABEL=$(printf "%02d" "$VOLUME")

sketchybar --set $NAME \
   icon="$ICON" \
   icon.padding_right=$PADDING \
   --set "${NAME}-info" \
     label="$LABEL%" \
