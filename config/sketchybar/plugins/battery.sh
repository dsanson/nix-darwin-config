#!/bin/sh

case "$SENDER" in
  "mouse.entered"|"mouse.exited"|"mouse.exited.global")
    DIR=$(dirname "$0")
    "$DIR"/mouse_over.sh 
    exit
    ;;
esac

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [[ $CHARGING != "" ]]; then
  #LABEL="⚡"
  #LABEL=""
  #LABEL="b"
  #LABEL="ϟ"
  LABEL="⚡︎"
fi

COLOR="${COLOR//x88/xbb}"
# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME \
    icon="$ICON" \
    label="$LABEL" \
    label.padding_left="-19" \
    label.color="$COLOR" \
    label.font.size="22.0" \
    --set $NAME-info \
      label="${PERCENTAGE}%"


# COLOR=0x88090A09
# POPUP_COLOR=0xff090A09
# LABEL_COLOR=0xffFBF6F2
# ICON_COLOR=0xffFBF6F2

